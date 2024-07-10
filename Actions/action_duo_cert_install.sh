#!/bin/bash
#
# Copyright Duo Security (C) 2022
#
# This script installs a device certificate for the currently logged in user
# v3.6
set -eu -o pipefail
# Set path explicitly so we're sure to only use the expected macOS built-ins
PATH=/bin:/usr/bin:/usr/sbin
ENROLLMENT_URL=aHR0cHM6Ly9kdW8xMDFjbXMuY3NzcGtpLmNvbS9DTVNOZXdBUEkvQ2VydEVucm9sbC8zL1BrY3MxMA==
MKEY=RE1TSjBaNkJVSlVLQ0xMUTIwMVk=
AKEY=REFTVVJaUkVMSVpPOUpWNkdEU0o=
APPLICATION_KEY=QjVPVzBOU2dPZ0V3V3VXRWhyMTJ6TkJnYjMzbWw=
RENEWAL_WINDOW=MTQ=
TEMPLATE_NAME=RHVvRGV2aWNlQXV0aGVudGljYXRpb24=
CERT_VALID_DAYS=MzY1
USERNAME=RFVPUEtJXGE0bXNxNzJ1Ym1uOHI4dzI=
PASSWORD=TmE4fCt7OUY7cUZzcDc+QiYlUjxkZnkk
APPLICATION_SECRET=TGVCWW5qVk1OOW1qUm5QWWFhU29wQ1NJc1ZEaHo2bUR2N09PNDlwMVl4c3dSRHI1ODlsbGRJZHRRRA==
ACL_TEAMIDS=(
    'EQHXZ8M8AV'  # Chrome
    'BQR82RBBHL'  # Slack
    'BJ4HAAB9B3'  # Zoom
    'HE4P42JBGN'  # BlueJeans
    'SDLYW7A8F3'  # HipChat
    '3Y9EC8WH48'  # GoToMeeting
    'Q79WDW8YH9'  # Evernote
    '2BUA8C4S2C'  # 1Password
    '57P38MF5GS'  # F5 Big Edge
    'VEKTX9H2N7'  # Electron
    'FMRT79K8DG'  # quip
    'JQ525L2MZD'  # Adobe Air
    '4XF3XNRN6Y'  # Vivaldi
    '477EAT77S3'  # Yandex
    'UBF8T346G9'  # Microsoft
    '483DWKW443'  # JAMF
    'PXPZ95SK77'  # Palo Alto Networks
    'M683GB7CPW'  # Box
    'UL7F34E7DN'  # Opera
    'FNN8Z5JMFP'  # Duo
    'DE8Y96K9QP'  # Cisco
    'BUX8SV4LQA'  # Symphony
    'KL8N8XSYF4'  # Brave
)
# Module level constants
CERTNAME='Duo Device Authentication'
ROOT_CERTNAME='Duo Endpoint Validation Root CA'
INTERMEDIATE_CERTNAME='Duo Endpoint Validation Issuing CA'
# We use a specific named file on disk for the key so that we can import
# it to keychain with a specific name
KEYFILE_NAME='Duo Device Authentication.pem'
DUO_KEYCHAIN_NAME='duo-auth.keychain'
DUO_KEYCHAIN_PASSWORD_LABEL='Duo Security'
TEMP_KEYCHAIN_NAME='duo-temp.keychain'
TEMP_KEYCHAIN_PASSWORD='temp-Password'
LAUNCHAGENT_LABEL='com.duosecurity.keychainhelper'
LAUNCHAGENT_FILENAME="${LAUNCHAGENT_LABEL}.plist"
if read -r -d '' LAUNCHAGENT_TEMPLATE << 'END_LAUNCH_AGENT_TEMPLATE'; then
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>Label</key>
   <string>{label}</string>
   <key>ProgramArguments</key>
    <array>
        <string>bash</string>
        <string>-c</string>
        <string>security unlock-keychain -p $(security find-generic-password -l "Duo Security" -w {login_keychain}) {duo_keychain}</string>
    </array>
   <key>RunAtLoad</key>
   <true/>
   <key>Nice</key>
   <integer>-20</integer>
   <key>ProcessType</key>
   <string>Interactive</string>
</dict>
</plist>
END_LAUNCH_AGENT_TEMPLATE
    :
fi
read -r -d '' OPENSSL_CONFIG_NO_ALT_NAMES_TEMPLATE << END_OPENSSL_CONFIG_NO_ALT_NAMES_TEMPLATE || true
[ req ]
default_bits = 2048
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn
[ dn ]
CN = {certname}
END_OPENSSL_CONFIG_NO_ALT_NAMES_TEMPLATE
read -r -d '' OPENSSL_CONFIG_ALT_NAMES_TEMPLATE << END_OPENSSL_CONFIG_ALT_NAMES_TEMPLATE || true
[ req ]
default_bits = 2048
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn
req_extensions = req_ext
[ dn ]
CN = {certname}
[ req_ext ]
subjectAltName = {alt_names}
END_OPENSSL_CONFIG_ALT_NAMES_TEMPLATE
AKEY_OID='1.3.6.1.4.1.48626.100.1'
MKEY_OID='1.3.6.1.4.1.48626.100.2'
DEVICE_ID_OID='1.3.6.1.4.1.48626.100.3'
USER_ID_OID='1.3.6.1.4.1.48626.100.4'
# Set in init_consts()
# making sure state of these variables is initially clear
unset CONSOLEUSER
unset CONSOLEUID
unset HOME_DIR
unset KEYCHAIN
unset LOGIN_KEYCHAIN
unset TEMP_KEYCHAIN
unset HARDWARE_UUID
unset COMPUTER_NAME
RUNNING_IN_DELETE_MODE=false
RUNNING_IN_CERT_CHECK_MODE=false
function as_user () {
    launchctl asuser "${CONSOLEUID}" sudo -u "${CONSOLEUSER}" -- "$@"
}
function find_certificate_pem () {
    as_user security find-certificate -a -c "${CERTNAME}" -Z -p "${KEYCHAIN}"
}
# Extract text:
#
# notAfter=Mar 21 20:14:51 2023 GMT
#          ^^^^^^^^^^^^^^^^^^^^^^^^
#
# from the cert PEM and convert to Unix epoch timestamp.
function get_cert_expiration() {
    local __cert_expiration
    __cert_expiration=$(find_certificate_pem | openssl x509 -enddate -noout | sed -e 's/notAfter=//')
    date -j -f "%b %d %H:%M:%S %Y %Z" "${__cert_expiration}" '+%s'
}
# Extract text:
#
# notBefore=Mar 21 20:14:51 2022 GMT
#           ^^^^^^^^^^^^^^^^^^^^^^^^
#
# from the cert PEM and convert to Unix epoch timestamp.
function get_cert_issuance() {
    local __cert_issuance
    __cert_issuance=$(find_certificate_pem | openssl x509 -startdate -noout | sed -e 's/notBefore=//')
    date -j -f "%b %d %H:%M:%S %Y %Z" "${__cert_issuance}" '+%s'
}
function seconds_to_days() {
    local __sec_in_day=$((60*60*24))
    echo $(($1 / __sec_in_day))
}
function get_cert_valid_days() {
    local __cert_expiration
    local __cert_issuance
    local __validity_secs
    __cert_expiration=$(get_cert_expiration)
    __cert_issuance=$(get_cert_issuance)
    __validity_secs=$(( __cert_expiration - __cert_issuance ))
    seconds_to_days ${__validity_secs}
}
function should_renew_certificate() {
    local __cert_expiration
    local __now
    local __remaining_seconds
    local __remaining_days
    __cert_expiration=$(get_cert_expiration)
    __now=$(date "+%s")
    __remaining_seconds=$(( __cert_expiration - __now ))
    __remaining_days=$(seconds_to_days ${__remaining_seconds})
    if [ "${__remaining_days}" -lt ${RENEWAL_WINDOW} ]; then
        return 0
    else
        return 1
    fi
}
function get_home_directory() {
    local __default_home="/Users/${CONSOLEUSER}"
    echo "${HOME:-$__default_home}"
}
# Extract text:
#
# Hardware:
#
#     Hardware Overview:
#       ...
#       Hardware UUID: 7ED25964-15D6-57D2-A045-505D457XXXXX
#                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
# from the system profiler.
function get_uuid() {
    system_profiler SPHardwareDataType | awk '/Hardware UUID:/ { print $NF }'
}
# Extract text:
#
#    MY-COMPUTER,NAME
#    ^^^^^^^^^^^ ^^^^
#
# Gets computer name from scutil stripping commas and white space leading and trailing.
function get_computer_name() {
    scutil --get ComputerName | sed -E 's/,//g; s/^[ \t]*//; s/[ \t]*$//'
}
function cert_has_correct_validity_duration() {
    local __cert_valid_days
    __cert_valid_days=$(get_cert_valid_days)
    if [[ ("${__cert_valid_days}" -eq "${CERT_VALID_DAYS}") || ("${__cert_valid_days}" -eq 366 && "${CERT_VALID_DAYS}" -eq 365) ]]; then
        return 0
    else
        return 1
    fi
}
# Match text:
#
# Certificate:
#    Data:
#        ...
#        X509v3 extensions:
#            ...
#            1.3.6.1.4.1.48626.100.1:
#                ..DAR7MNODZPB0XXXXXXXX
#                ^^^^^^^^^^^^^^^^^^^^^^
#            1.3.6.1.4.1.48626.100.2:
#                ..DME1EY6YN5PC8XXXXXXX
#                ^^^^^^^^^^^^^^^^^^^^^^
#
# from the cert PEM.
function cert_has_required_attributes() {
    local __akey_match
    local __akey_pattern
    local __mkey_match
    local __mkey_pattern
    local __cert_data
    __cert_data=$(find_certificate_pem | openssl x509 -text -noout)
    # Output of $(echo | sed) may be zero with no match
    __akey_pattern="${AKEY_OID}:.*\n.*${AKEY}"
    __akey_match=$(echo "${__cert_data}" | sed -En "{N; /${__akey_pattern}/{=;p;}; D;}")
    __mkey_pattern="${MKEY_OID}:.*\n.*${MKEY}"
    __mkey_match=$(echo "${__cert_data}" | sed -En "{N; /${__mkey_pattern}/{=;p;}; D;}")
    if [[ -z "${__akey_match}" ]]; then
        return 1
    elif [[ -z "${__mkey_match}" ]]; then
        return 1
    fi
    return 0
}
function exit_if_running_as_root() {
    local __home_dir
    __home_dir=$(get_home_directory)
    if [ "$__home_dir" == '/var/root' ] || [ "${CONSOLEUSER}" == 'root' ]; then
        echo "=== Error: This script cannot run as the root user. It must be invoked as a regular user with root privileges (sudo)." 1>&2
        exit 1
    fi
}
function usage() {
    local __arg_prefix_length
    local __prefix
    local __sequence
    __arg_prefix_length=$(echo "usage:" "$(basename "$0")" | wc -c | sed 's/^[ \t]*//')
    __sequence=$(seq 1 "${__arg_prefix_length}")
    __prefix=$(for i in ${__sequence}; do echo -n " "; done)
    cat << END_USAGE
usage: $(basename "$0") [-h] [--enrollment_url ENROLLMENT_URL]
${__prefix}[--application_key_text APPLICATION_KEY_TEXT]
${__prefix}[--akey AKEY] [--mkey MKEY]
${__prefix}[--renewal_window_days RENEWAL_WINDOW_DAYS]
${__prefix}[--template_name TEMPLATE_NAME]
${__prefix}[--valid_days VALID_DAYS]
${__prefix}[--username USERNAME] [--password PASSWORD]
${__prefix}[--application_secret APPLICATION_SECRET]
This script installs a device certificate for the currently logged in user
optional arguments:
  -h, --help            show this help message and exit
  --enrollment_url ENROLLMENT_URL
  --application_key_text APPLICATION_KEY_TEXT
  --akey AKEY
  --mkey MKEY
  --renewal_window_days RENEWAL_WINDOW_DAYS
  --template_name TEMPLATE_NAME
  --valid_days VALID_DAYS
  --username USERNAME
  --password PASSWORD
  --application_secret APPLICATION_SECRET
END_USAGE
}
function parse_space_arguments() {
    while [[ $# -gt 0 ]]; do
        # shellcheck disable=SC2221,SC2222
        case $1 in
            --enrollment_url)
                arg_enrollment_url="$2"
                shift
                shift
                ;;
            --application_key_text)
                arg_application_key_text="$2"
                shift
                shift
                ;;
            --akey)
                arg_akey="$2"
                shift
                shift
                ;;
            --mkey)
                arg_mkey="$2"
                shift
                shift
                ;;
            --renewal_window_days)
                arg_renewal_window_days="$2"
                shift
                shift
                ;;
            --template_name)
                arg_template_name="$2"
                shift
                shift
                ;;
            --valid_days)
                arg_valid_days="$2"
                shift
                shift
                ;;
            --username)
                arg_username="$2"
                shift
                shift
                ;;
            --password)
                arg_password="$2"
                shift
                shift
                ;;
            --application_secret)
                arg_application_secret="$2"
                shift
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -v)
                set -x
                shift
                ;;
            -*|--*)
                # if the next argument is not a flag, ignore it too.
                if [ -n "${2:-}" ]; then
                    if echo "$2" | grep -Ev "^-"; then
                        shift
                    fi
                fi
                shift
                ;;
            DUO-CERTIFICATE-DELETE-MODE)
                RUNNING_IN_DELETE_MODE=true
                shift
                ;;
            DUO-CERTIFICATE-CHECK-MODE)
                RUNNING_IN_CERT_CHECK_MODE=True
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
}

function parse_equal_arguments() {
    for i in "$@"; do
        # shellcheck disable=SC2221,SC2222
        case $i in
            --enrollment_url=*)
                arg_enrollment_url="${i#*=}"
                ;;
            --application_key_text=*)
                arg_application_key_text="${i#*=}"
                ;;
            --akey=*)
                arg_akey="${i#*=}"
                ;;
            --mkey=*)
                arg_mkey="${i#*=}"
                ;;
            --renewal_window_days=*)
                arg_renewal_window_days="${i#*=}"
                ;;
            --template_name=*)
                arg_template_name="${i#*=}"
                ;;
            --valid_days=*)
                arg_valid_days="${i#*=}"
                ;;
            --username=*)
                arg_username="${i#*=}"
                ;;
            --password=*)
                arg_password="${i#*=}"
                ;;
            --application_secret=*)
                arg_application_secret="${i#*=}"
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*|--*)
                ;;
            *)
                ;;
        esac
    done
}
function parse_arguments() {
    parse_space_arguments "${@}"
    parse_equal_arguments "${@}"
    if $RUNNING_IN_DELETE_MODE && $RUNNING_IN_CERT_CHECK_MODE; then
        echo "=== Can not run in both DELETE and CERT CHECK mode!" 1>&2
        exit 1
    fi
}
function fetch_config() {
    if [ "${1-}" ]; then
        parse_arguments "${@}"
    fi
    local __required_args=( \
        'arg_enrollment_url' 'arg_application_key_text' 'arg_akey' 'arg_mkey' 'arg_renewal_window_days' 'arg_template_name' \
        'arg_valid_days' 'arg_username' 'arg_password' 'arg_application_secret' )
    local __arg_count=0
    for i in "${__required_args[@]}"; do
        if [ -n "${!i-}" ]; then
            __arg_count=$(( __arg_count + 1 ))
        fi
    done
    if [[ ${__arg_count} -gt 0 ]]; then
        if [[ ${__arg_count} -lt ${#__required_args[@]} ]]; then
            echo '=== All command line args must be passed' 1>&2
            return 1
        fi
        ENROLLMENT_URL=$(echo -n "${arg_enrollment_url}" | base64 -D)
        USERNAME=$(echo -n "${arg_username}" | base64 -D)
        PASSWORD=$(echo -n "${arg_password}" | base64 -D)
        APPLICATION_KEY="${arg_application_key_text}"
        APPLICATION_SECRET=$(echo -n "${arg_application_secret}" | base64 -D)
        AKEY=$(echo -n "${arg_akey}" | base64 -D)
        MKEY=$(echo -n "${arg_mkey}" | base64 -D)
        RENEWAL_WINDOW=$(echo -n "${arg_renewal_window_days}" | base64 -D)
        TEMPLATE_NAME=$(echo -n "${arg_template_name}" | base64 -D)
        CERT_VALID_DAYS=$(echo -n "${arg_valid_days}" | base64 -D)
        return 0
    fi
    ENROLLMENT_URL=$(echo -n "${ENROLLMENT_URL}" | base64 -D)
    USERNAME=$(echo -n "${USERNAME}" | base64 -D)
    PASSWORD=$(echo -n "${PASSWORD}" | base64 -D)
    APPLICATION_SECRET=$(echo -n "${APPLICATION_SECRET}" | base64 -D)
    AKEY=$(echo -n "${AKEY}" | base64 -D)
    MKEY=$(echo -n "${MKEY}" | base64 -D)
    RENEWAL_WINDOW=$(echo -n "${RENEWAL_WINDOW}" | base64 -D)
    TEMPLATE_NAME=$(echo -n "${TEMPLATE_NAME}" | base64 -D)
    CERT_VALID_DAYS=$(echo -n "${CERT_VALID_DAYS}" | base64 -D)
}
function init_consts() {
    CONSOLEUSER=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
    CONSOLEUID=$(id -u "${CONSOLEUSER}")
    HOME_DIR=$(get_home_directory)
    LOGIN_KEYCHAIN="${HOME_DIR}/Library/Keychains/login.keychain"
    KEYCHAIN="${HOME_DIR}/Library/Keychains/${DUO_KEYCHAIN_NAME}"
    TEMP_KEYCHAIN="${HOME_DIR}/Library/Keychains/${TEMP_KEYCHAIN_NAME}"
    HARDWARE_UUID=$(get_uuid)
    COMPUTER_NAME=$(get_computer_name)
    local __required_configs=( 'ENROLLMENT_URL' 'USERNAME' 'PASSWORD' 'APPLICATION_KEY' 'APPLICATION_SECRET' )
    local __arg_count=0
    for i in "${__required_configs[@]}"; do
        if [[ -n "${!i-}" ]]; then
            __arg_count=$(( __arg_count + 1 ))
        fi
    done
    if [[ ${__arg_count} -lt ${#__required_configs[@]} ]]; then
        echo '=== Invalid configuration parameters' 1>&2
        return 1
    fi
}
function get_hashes() {
    local __common_name="${1}"
    local __keychain="${2}"
    local __require_private_key="${3:-false}"
    local __error_log_only="${4:-false}"
    if ! ${__error_log_only} ; then
        echo "=== Finding certificates matching CN=${__common_name}" 1>&2
    fi
    declare -a __hashes
    if ${__require_private_key}; then
        local __filtered_data
        local __raw_data
        __raw_data=$(as_user security find-identity "${__keychain}")
        __filtered_data=$(echo "${__raw_data}" | grep "${__common_name}")
        # Extract Text:
        #
        # 1) 6274F1777608080F1813B8C835D06301DA2A9F2E "Duo Security Trusted Endpoint" (CSSMERR_TP_NOT_TRUSTED)
        #    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        #
        # And add it to the array
        while IFS='' read -r line; do
            if [ ${#__hashes[*]} -eq 0 ] || [[ ! " ${__hashes[*]} " == *" ${line} "* ]]; then
                __hashes+=("${line}")
            fi
        done < <(echo "${__filtered_data}"| sed -E 's/^.*\) ([^ ]+).*/\1/')
    else
        while IFS='' read -r line; do
            __hashes+=("${line}")
        done < <(\
            as_user security find-certificate -a -c "${__common_name}" -Z "${__keychain}" | \
            grep -e 'SHA-1 hash:' | sed -E 's/^SHA-1 hash: (.*)/\1/; s/[ \t]//g'
        )
    fi
    if ! ${__error_log_only}; then
        if [[ ${#__hashes[@]} -gt 1 ]]; then
            echo "=== Multiple certificates matching CN=${__common_name}" 1>&2
        elif [[ ${#__hashes[@]} -eq 1 ]]; then
            echo "=== Cert hit for CN=${__common_name}" 1>&2
        else
            echo "=== No cert found for CN=${__common_name}" 1>&2
       fi
    fi
    if [ ${#__hashes[@]} -gt 0 ]; then
        for i in "${__hashes[@]}"; do
            echo "${i}"
        done
    fi
}
function delete_certs() {
    local __common_name="${1}"
    local __keychain="${2}"
    local __error_log_only="${3:-false}"
    if ! "${__error_log_only}"; then
        echo "=== Deleting identity with CN=${__common_name}..." 1>&2
    fi
    declare -a __hashes
    while IFS='' read -r __hash; do
        __hashes+=("${__hash}")
    done < <(get_hashes "${__common_name}" "${__keychain}" "${__error_log_only}")
    if [ ${#__hashes[*]} -gt 0 ]; then
        for cert_hash in "${__hashes[@]}"; do
            if ! as_user security delete-identity -Z "${cert_hash}" "${__keychain}"; then
                # Older Macs don't support delete-identity.
                # Fallback to delete-certificate.
                echo "=== Deleting certificate with CN=${__common_name}..." 1>&2
                if ! as_user security delete-certificate -Z "${cert_hash}" "${__keychain}"; then
                    echo "=== Deleting cert failed with common_name: ${__common_name}, keychain: ${__keychain}"
                fi
            fi
        done
    fi
}
function duo_key_chain_exists() {
    # Check if the custom Duo keychain exists.
    local __keychains
    __keychains=$(as_user security list-keychains -d user | grep "${KEYCHAIN}")
    if [ -n "${__keychains}" ] ; then
        # shellcheck disable=SC2061
        # We want to match on e.g. 'duo-auth.keychain-db'
        if [[ -n $(find "${HOME_DIR}/Library/Keychains" -type f -name "${DUO_KEYCHAIN_NAME}"*) ]]; then
            return 0
        fi
    fi
    return 1
}
function get_duo_keychain_password() {
    as_user security find-generic-password -l "${DUO_KEYCHAIN_PASSWORD_LABEL}" -w "${LOGIN_KEYCHAIN}" 2>/dev/null || true
}
function generate_duo_keychain_password() {
    echo "=== Generating a password for the duo-auth keychain..." 1>&2
    local __password
    __password=$(echo "$(date)" ${RANDOM} | shasum | base64 | head -c20)
    if as_user security add-generic-password -a "${DUO_KEYCHAIN_NAME}" \
        -s "${DUO_KEYCHAIN_PASSWORD_LABEL}" -l "${DUO_KEYCHAIN_PASSWORD_LABEL}" \
        -w "${__password}" -A -U "${LOGIN_KEYCHAIN}"; then
            echo "${__password}"
            return 0
    fi
    echo "=== Failed to add new password to keychain with status code: $?" 1>&2
    return 1
}
function create_duo_keychain() {
    local __password="${1}"
    echo "=== Creating the duo-auth keychain..." 1>&2
    if ! as_user security create-keychain -p "${__password}" "${KEYCHAIN}"; then
        echo "=== Create keychain failed" 1>&2
        return 1
    fi
    if ! as_user security set-keychain-settings "${KEYCHAIN}"; then
        echo "=== Setting keychain settings failed" 1>&2
        return 1
    fi
    # Extract text:
    #
    #     "/Users/username/Library/Keychains/login.keychain-db"
    #      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #     "/Users/username/Library/Keychains/duo-auth.keychain-db"
    #      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    #
    # from keychain list.
    declare -a __keychain_arr
    local __original_ifs="${IFS}"
    while IFS='' read -r line; do
        __keychain_arr+=("${line}")
    done < <(as_user security list-keychains -d user | sed -E 's/^[ \t]*//; s/\"//g; s/-db$//;')
    if [[ ! " ${__keychain_arr[*]} " == *" ${LOGIN_KEYCHAIN} "* ]]; then
        __keychain_arr+=("${LOGIN_KEYCHAIN}")
    fi
    if [[ ! " ${__keychain_arr[*]} " == *" ${KEYCHAIN} "* ]]; then
        __keychain_arr+=("${KEYCHAIN}")
    fi
    if as_user security list-keychains -d user -s "${__keychain_arr[@]}"; then
        return 0
    fi
    echo "=== Listing keychain failed" 1>&2
    return 1
}
function unlock_duo_keychain() {
    local __password="${1}"
    echo "=== Unlocking the duo-auth keychain..."
    if as_user security unlock-keychain -p "${__password}" "${DUO_KEYCHAIN_NAME}"; then
        return 0
    fi
    echo "=== Unlocking duo-auth keychain failed" 1>&2
    return 1
}
function lock_duo_keychain() {
   as_user security lock-keychain "${DUO_KEYCHAIN_NAME}"
}
function delete_duo_keychain() {
    echo "=== Deleting the duo-auth keychain..." 1>&2
    if as_user security delete-keychain "${KEYCHAIN}"; then
        return 0
    fi
    echo '=== Deleting duo-auth keychain failed' 1>&2
    return 1
}
function generate_launch_agent() {
    echo "${LAUNCHAGENT_TEMPLATE}" | \
        sed -E "s;\{label\};${LAUNCHAGENT_LABEL};g; s;\{login_keychain\};${LOGIN_KEYCHAIN};g; s;\{duo_keychain\};${KEYCHAIN};g"
}
function is_launch_agent_valid() {
    if [ ! -e "${HOME_DIR}/Library/LaunchAgents/${LAUNCHAGENT_FILENAME}" ]; then
        return 1
    fi
    local __difference
    local __launchagent
    local __ondisk_agent
    __launchagent=$(generate_launch_agent)
    read -r -d '' __ondisk_agent < "${HOME_DIR}/Library/LaunchAgents/${LAUNCHAGENT_FILENAME}" || true
    __difference=$(diff -u <(echo "${__ondisk_agent}") <(echo "${__launchagent}"))
    if [[ -z "${__difference}" ]]; then
        return 0
    fi
    echo "=== Launch agent misconfigured." 1>&2
    return 1
}
function configure_launchagent() {
    echo "=== Checking launch agent..." 1>&2
    if [[ ! -e "${HOME_DIR}/Library/LaunchAgents" ]]; then
        if ! mkdir "${HOME_DIR}/Library/LaunchAgents"; then
            echo "=== Creating launchagent directory failed." 1>&2
            return 1
        fi
    fi
    if is_launch_agent_valid; then
        echo "=== Launch agent found" 1>&2
    else
        echo "=== Configuring the launchagent to unlock the duo-auth keychain..."
        local __agent_file="${HOME_DIR}/Library/LaunchAgents/${LAUNCHAGENT_FILENAME}"
        generate_launch_agent > "${__agent_file}"
        if ! launchctl load "${__agent_file}"; then
            echo "=== Loading launch agent failed." 1>&2
            return 1
        fi
    fi
}
function delete_launchagent() {
    echo "=== Deleting the launchagent to unlock the duo-auth keychain..." 1>&2
    local __agent_file="${HOME_DIR}/Library/LaunchAgents/${LAUNCHAGENT_FILENAME}"
    launchctl unload "${__agent_file}"
    rm -f "${__agent_file}"
}
function configure_duo_keychain() {
    local __password
    __password=$(get_duo_keychain_password)
    if [[ -n "${__password}" ]]; then
        echo "=== Keychain password found..." 1>&2
    else
        echo "=== No keychain password found. Creating..." 1>&2
        __password=$(generate_duo_keychain_password)
        if [[ -z "${__password}" ]]; then
            echo "=== Failed to create keychain password." 1>&2
            return 1
        fi
    fi
    if duo_key_chain_exists; then
        echo "=== Keychain already exists..." 1>&2
        lock_duo_keychain
        if ! unlock_duo_keychain "${__password}"; then
            echo "=== Failed to unlock Duo keychain. Recreating Duo keychain..." 1>&2
            delete_duo_keychain || true
            if ! create_duo_keychain "${__password}" && unlock_duo_keychain "${__password}"; then
                return 1
            fi
        fi
    else
        echo "=== Duo keychain not set up. Deleting keychain(if exists) and creating a new keychain." 1>&2
        delete_duo_keychain || true
        if ! create_duo_keychain "${__password}"; then
            return 1
        fi
    fi
    configure_launchagent
}
function set_key_partition_list() {
    echo "=== Setting the partition_id ACL for known browsers and apps..." 1>&2
    local __password
    __password=$(get_duo_keychain_password)
    if [[ -z "${__password}" ]]; then
        echo "=== Failed to get duo keychain password."
        return 1
    fi
    local __acl='apple-tool:,apple:,unsigned:'
    for teamid in "${ACL_TEAMIDS[@]}"; do
        __acl+=",teamid:${teamid}"
    done
    as_user security set-key-partition-list -l "Imported Private Key" -S "${__acl}" -k "${__password}" -s "${KEYCHAIN}" 1>/dev/null 2>/dev/null || true
}
function delete_duo_keychain_certs() {
    if delete_certs "${CERTNAME}" "${KEYCHAIN}" \
        && delete_certs "${ROOT_CERTNAME}" "${KEYCHAIN}" \
        && delete_certs "${INTERMEDIATE_CERTNAME}" "${KEYCHAIN}"; then
            return 0
    fi
    return 1
}
function set_chrome_path_defaults() {
    defaults write /Library/Preferences/com.google.Chrome.plist \
        AutoSelectCertificateForUrls -array-add -string \
        '{"pattern":"https://[*.]duosecurity.com/frame","filter":{}}'
}
function set_chrome_namespace_defaults() {
    defaults write com.google.Chrome \
        AutoSelectCertificateForUrls -array-add -string \
        '{"pattern":"https://[*.]duosecurity.com/frame","filter":{}}'
}
function read_chrome_path_defaults() {
    defaults read /Library/Preferences/com.google.Chrome.plist AutoSelectCertificateForUrls
}
function read_chrome_namesapce_defaults() {
    defaults read com.google.Chrome AutoSelectCertificateForUrls
}
function verify_chrome_defaults() {
    if [[ "$(read_chrome_path_defaults 2>/dev/null)" == *"duosecurity.com/frame"* ]]; then
        return 0
    fi
    if [[ "$(read_chrome_namespace_defaults 2>/dev/null)" == *"duosecurity.com/frame"* ]]; then
        return 0
    fi
    return 1
}
function verify_safari_defaults() {
    if [[ "$(as_user security get-identity-preference -s '*.duosecurity.com' "${KEYCHAIN}")" == *"Duo Device Authentication"* ]]; then
        return 0
    fi
    return 1
}
function set_safari_defaults() {
    as_user security set-identity-preference -c 'Duo Device Authentication' -s '*.duosecurity.com' "${KEYCHAIN}"
}
function set_defaults() {
    echo "=== Checking Chrome defaults..." 1>&2
    if verify_chrome_defaults; then
        echo "=== Expected Chrome policy already configured. Skipping..." 1>&2
    else
        echo "=== Setting Chrome defaults for the Duo client certificate..." 1>&2
        if ! set_chrome_path_defaults; then
            set_chrome_namespace_defaults 2>/dev/null || true
        fi
        if ! verify_chrome_defaults; then
            echo "=== It appears setting Chrome defaults failed. User might see Chrome prompts during login. Continue..." 1>&2
        fi
    fi
    echo "=== Checking Safari identity preference..." 1>&2
    if verify_safari_defaults; then
        echo "=== Expected Safari policy already configured. Skipping..." 1>&2
    else
        echo "=== Setting Safari identify preference for the Duo client certificate..." 1>&2
        set_safari_defaults 2>/dev/null || true
        if ! verify_safari_defaults; then
            echo "=== It appears setting Safari defaults failed. Safari might not be reported as a Trusted Endpoint. Continue..." 1>&2
        fi
    fi
}
function cleanup() {
    local __temp_dir=$1
    local __keyfile_uri="${__temp_dir}/${KEYFILE_NAME}"
    echo "=== Cleaning up temporary files..." 1>&2
    rm -f "${__keyfile_uri}" || true
    rm -rf "${__temp_dir}" || true
}
function setup() {
    echo "=== Performing preinstall checks..." 1>&2
    exit_if_running_as_root
    if ! configure_duo_keychain; then
        echo "=== Preinstall checks failed. Exiting" 1>&2
        exit 1
    fi
    # Delete any existing Duo certs in the login keychain. We need to do
    # this because we may have existing machines configured with the Duo
    # cert in the login keychain instead of the custom Duo keychain.
    # This could happen if manual enrollement was previously used.
    delete_certs "${CERTNAME}" "${LOGIN_KEYCHAIN}" true
    delete_certs "${ROOT_CERTNAME}" "${LOGIN_KEYCHAIN}" true
    delete_certs "${INTERMEDIATE_CERTNAME}" "${LOGIN_KEYCHAIN}" true
    local __multiple_certs=false
    local __hash
    local __cert_hash
    local __intermediate_hash
    local __root_hash
    declare -a __hashes
    while IFS='' read -r __hash; do
        __hashes+=("${__hash}")
    done < <(get_hashes "${CERTNAME}" "${KEYCHAIN}" true)
    if [[ ${#__hashes[@]} -eq 1 ]]; then
        __cert_hash=${__hashes[0]}
    elif [[ ${#__hashes[@]} -gt 1 ]]; then
        __multiple_certs=true
    fi
    unset __hashes
    declare -a __hashes
    while IFS='' read -r __hash; do
        __hashes+=("${__hash}")
    done < <(get_hashes "${ROOT_CERTNAME}" "${KEYCHAIN}")
    if [[ ${#__hashes[@]} -eq 1 ]]; then
        __root_hash=${__hashes[0]}
    elif [[ ${#__hashes[@]} -gt 1 ]]; then
        __multiple_certs=true
    fi
    unset __hashes
    declare -a __hashes
    while IFS='' read -r __hash; do
        __hashes+=("${__hash}")
    done < <(get_hashes "${INTERMEDIATE_CERTNAME}" "${KEYCHAIN}")
    if [[ ${#__hashes[@]} -eq 1 ]]; then
        __intermediate_hash=${__hashes[0]}
    elif [[ ${#__hashes[@]} -gt 1 ]]; then
        __multiple_certs=true
    fi
    local __clear_existing_certs=false
    if [[ -n "${__cert_hash-}" ]]; then
        if should_renew_certificate; then
            __clear_existing_certs=true
            echo "=== Existing certificate is within expiration period. Renewing..." 1>&2
        fi
        if ! cert_has_required_attributes; then
            __clear_existing_certs=true
            echo "=== Existing certificate does not have required attributes..." 1>&2
        fi
        if ! cert_has_correct_validity_duration; then
            __clear_existing_certs=true
            echo "=== Existing certificate does not have the proper validity duration..." 1>&2
        fi
        if ${__multiple_certs}; then
            __clear_existing_certs=true
            echo "=== Multiple user, intermediate, or root certs detected..." 1>&2
        fi
    fi
    if $__clear_existing_certs; then
        echo "=== Existing certs in an unclean state. Cleaning and installing a new certificate..." 1>&2
        if ! delete_duo_keychain_certs; then
            echo "=== Failed to clean up existing certs"
            exit 1
        fi
    fi
    if [[ -n "${__cert_hash-}" && -n "${__root_hash-}" && -n "${__intermediate_hash-}" ]]; then
        if ! $__clear_existing_certs; then
            echo "=== The cert for the current user already exists. Skipping installation..." 1>&2
            if ! set_defaults; then
                echo "=== Error while setting browser defaults"
                exit 1
            fi
            if ! set_key_partition_list; then
                exit 1
            fi
            echo "=== All checks complete" 1>&2
            exit 0
        fi
    fi
    echo "=== Preinstall checks complete!"
}
function generate_openssl_config() {
    local __extensions=""
    if [[ -n "${HARDWARE_UUID}" ]]; then
        __extensions="otherName:${DEVICE_ID_OID};UTF8:${HARDWARE_UUID}"
    fi
    if [[ -n "${COMPUTER_NAME}" && -n "${CONSOLEUSER}" ]]; then
        __extensions+=",otherName:${USER_ID_OID};UTF8:${COMPUTER_NAME}/${CONSOLEUSER}"
    fi
    __extensions=$(echo "${__extensions}" | sed -E 's/^,//')
    if [[ -n "${__extensions}" ]] ; then
        echo "${OPENSSL_CONFIG_ALT_NAMES_TEMPLATE}" | sed -E "s|\{alt_names\}|${__extensions}|; s|\{certname\}|${CERTNAME}|;"
    else
        echo "${OPENSSL_CONFIG_NO_ALT_NAMES_TEMPLATE}" | sed -E "s|\{certname\}|${CERTNAME}|;"
    fi
}
function get_certificate() {
    local __auth_string
    local __cert_data
    local __csr="${1}"
    local __curl_cmd=()
    local __now
    local __req_body
    local __req_len
    local __server_res
    local __signature
    echo "=== Generating client certificate from certificate signing request..." 1>&2
    __now=$(date -u '+%Y-%m-%dT%H:%M:%S.000000')
    read -r -d '' __req_body << EOF || true
    {
        "timestamp": "${__now}",
        "request": {
            "Flags": 0,
            "TemplateName": "${TEMPLATE_NAME}",
            "Pkcs10Request": "${__csr}"
        }
    }
EOF
    __signature=$( echo -n "${__req_body}" | openssl dgst -binary -sha1 -hmac "${APPLICATION_SECRET}" | base64 )
    __req_len=$( echo -n "${__req_body}" | wc -c | sed -E 's/^[ \t]+//')
    __auth_string=$( echo -n "${USERNAME}:${PASSWORD}" | base64)
    __curl_cmd=(curl --fail -H "Content-Type: application/json" \
        -H "Content-Length: ${__req_len}" \
        -H "Authorization: Basic ${__auth_string}" \
        -H "X-CSS-CMS-AppKey: ${APPLICATION_KEY}" \
        -H "X-CSS-CMS-Signature: ${__signature}" \
        -X POST -d "${__req_body}" "${ENROLLMENT_URL}")
    if ! __server_res=$("${__curl_cmd[@]}"); then
        echo "=== Request for CA signature failed" 1>&2
        return 1
    fi
    # The weird newline substitution is for mac OSX 10.x compatibility.
    __cert_data=$( echo "${__server_res}" | sed -E 's/^.*Certificates":"([^"]*)".*$/\1/; s/\\r\\n/\'$'\n/g;' )
    echo "-----BEGIN CERTIFICATE-----" && echo "${__cert_data}" && echo -n "-----END CERTIFICATE-----"
}
function write_certificate_to_keychain() {
    local __cert_file="${1}"
    local __key_file="${2}"
    echo "=== Writing keychain entries for client certificate and private key..." 1>&2
    if [[ -n "${CONSOLEUSER}" && "${CONSOLEUSER}" != "root" ]]; then
        launchctl asuser "${CONSOLEUID}" security import "${__key_file}" -x -A -k "${KEYCHAIN}"
        launchctl asuser "${CONSOLEUID}" security import "${__cert_file}" -k "${KEYCHAIN}"
    else
        echo "=== Running without console user or as root user, skipping importing key and cert ===" 1>&2
        return 1
    fi
}
function duo_keychain_exists() {
    local __keychains
    __keychains=$(as_user security list-keychains -d user)
    local __keychain_in_list=false
    local __keychain_on_disk=false
    if [[ "${__keychains}" == *"${KEYCHAIN}"* ]]; then
        __keychain_in_list=true
    fi
    # shellcheck disable=SC2061
    # We want to match on e.g. 'duo-auth.keychain-db'
    if [[ -n $(find "${HOME_DIR}/Library/Keychains/" -type f -name "${DUO_KEYCHAIN_NAME}"* 2>/dev/null) ]]; then
        __keychain_on_disk=true
    fi
    if $__keychain_on_disk && $__keychain_in_list; then
        return 0
    fi
    return 1
}
function create_temp_keychain() {
    echo "=== Creating temp keychain..." 1>&2
    if ! as_user security create-keychain -p "${TEMP_KEYCHAIN_PASSWORD}" "${TEMP_KEYCHAIN}"; then
        echo "=== Create temp keychain failed" 1>&2
        return 1
    fi
    return 0
}
function delete_temp_keychain() {
    echo "=== Deleting temp keychain..."
    if ! as_user security delete-keychain "${TEMP_KEYCHAIN}"; then
        echo "=== Delete temp keychain failed" 1>&2
        return 1
    fi
    return 0
}
function trigger_keychain_event() {
    if create_temp_keychain; then
        if ! delete_temp_keychain; then
            echo "=== Error triggering keychain event..."
            return 1
        fi
    else
        echo "=== Error triggering keychain event..."
        return 1
    fi
}
function main() {
    fetch_config "$@"
    if ! init_consts "$@"; then
        echo "=== Error setting up initial constant variables..." 1>&2
        exit 1
    fi
    if "${RUNNING_IN_DELETE_MODE}"; then
        echo "=== Deleting Duo certificates while running in DELETE MODE..." 1>&2
        local __all_success=true
        if ! delete_duo_keychain_certs; then
            __all_success=false
        fi
        if ! delete_duo_keychain; then
            __all_success=false
        fi
        if ! delete_launchagent; then
            __all_success=false
        fi
        if $__all_success; then
            exit 0
        fi
        exit 1
    fi
    if "${RUNNING_IN_CERT_CHECK_MODE}"; then
        local __hashes
        echo "=== Checking for Duo certs while in CERT CHECK MODE..." 1>&2
        __hashes=$( get_hashes "${CERTNAME}" "${KEYCHAIN}" true )
        local __has_valid_cert=true
        if [[ ! $(echo "${__hashes}" | wc -l | sed -E 's/^[ \t]*//') -eq 1 ]]; then
            __has_valid_cert=false
        fi
        __hashes=$( get_hashes "${ROOT_CERTNAME}" "${KEYCHAIN}" )
        if [[ ! $(echo "${__hashes}" | wc -l | sed -E 's/^[ \t]*//') -eq 1 ]]; then
            __has_valid_cert=false
        fi
        __hashes=$( get_hashes "${INTERMEDIATE_CERTNAME}" "${KEYCHAIN}" )
        if [[ ! $(echo "${__hashes}" | wc -l | sed -E 's/^[ \t]*//') -eq 1 ]]; then
            __has_valid_cert=false
        fi
        local __keychain_password
        __keychain_password=$(get_duo_keychain_password)
        local __keychain_unlocked=false
        if [[ -n "${__keychain_password}" ]]; then
            if duo_keychain_exists; then
                lock_duo_keychain || true
                if unlock_duo_keychain "${__keychain_password}"; then
                    __keychain_unlocked=true
                fi
            fi
        fi
        if $__has_valid_cert && $__keychain_unlocked && is_launch_agent_valid; then
            echo "<result>True</result>"
        else
            echo "<result>False</result>"
        fi
        exit 0
    fi
    setup
    local __openssl_config
    __openssl_config=$(generate_openssl_config)
    TMPDIR=$(mktemp -d -t "$(basename "$0")") || exit 1
    # Cause temp cert files to be removed on exit
    trap 'cleanup ${TMPDIR}' EXIT
    openssl_conf_file=$(mktemp -t "$(basename "$0")") || exit 1
    cert_file=$(mktemp -t "$(basename "$0")") || exit 1
    echo "${__openssl_config}" > "$openssl_conf_file"
    csr_der=$(openssl req -new -config "${openssl_conf_file}" \
        -keyout "${TMPDIR}/${KEYFILE_NAME}" -outform DER | base64)
    cert_pem=$(get_certificate "${csr_der}")
    echo "${cert_pem}" > "${cert_file}"
    write_certificate_to_keychain "${cert_file}" "${TMPDIR}/${KEYFILE_NAME}"
    set_defaults
    set_key_partition_list
    trigger_keychain_event
}
main "$@"
 