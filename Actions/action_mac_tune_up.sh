#!/bin/bash

set -euo pipefail

usage() {
  cat <<'EOF'
Mac Tune-Up Utility

Usage: action_mac_tune_up.sh [options]

Options:
  -c, --clear-user-caches       Remove contents of ~/Library/Caches for the logged-in user.
  -s, --clear-saved-state       Remove contents of ~/Library/Saved Application State.
  -l, --rotate-logs             Trigger system log rotation with newsyslog.
  -m, --reindex-spotlight       Rebuild Spotlight metadata index (default volume: /).
      --spotlight-volume PATH   Additional volume to include when reindexing Spotlight.
  -a, --app-cache IDENTIFIER    Remove an individual application cache directory within
                                ~/Library/Caches (repeatable).
      --dry-run                 Print the actions that would be taken without executing them.
  -y, --yes                     Skip interactive confirmations.
  -h, --help                    Show this help message and exit.

At least one maintenance option must be supplied.
EOF
}

log() {
  local level="$1"; shift
  printf '[%s] %s\n' "$level" "$*"
}

confirm() {
  local prompt="$1"
  if [[ "$ASSUME_YES" == "true" ]]; then
    return 0
  fi
  read -r -p "$prompt [y/N]: " response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      log INFO "Skipped: $prompt"
      return 1
      ;;
  esac
}

run_command() {
  if [[ "$DRY_RUN" == "true" ]]; then
    log INFO "[dry-run] $*"
    return 0
  fi

  if "$@"; then
    return 0
  else
    local status=$?
    log ERROR "Command failed ($status): $*"
    return $status
  fi
}

remove_directory_contents() {
  local target_dir="$1"

  if [[ ! -d "$target_dir" ]]; then
    log WARN "Directory not found: $target_dir"
    return 0
  fi

  if confirm "Remove contents of $target_dir?"; then
    if [[ "$DRY_RUN" == "true" ]]; then
      log INFO "[dry-run] Would remove contents of $target_dir"
    else
      # Remove only the contents to avoid accidentally deleting the directory itself.
      find "$target_dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
      log INFO "Cleared $target_dir"
    fi
  fi
}

rotate_logs() {
  if ! command -v newsyslog >/dev/null 2>&1; then
    log WARN "newsyslog is not available; skipping log rotation"
    return 0
  fi

  if confirm "Rotate system logs with newsyslog?"; then
    run_command /usr/sbin/newsyslog && log INFO "Triggered log rotation"
  fi
}

reindex_spotlight() {
  if ! command -v mdutil >/dev/null 2>&1; then
    log WARN "mdutil is not available; skipping Spotlight reindex"
    return 0
  fi

  local volumes=("$@")
  if [[ ${#volumes[@]} -eq 0 ]]; then
    volumes=("/")
  fi

  for volume in "${volumes[@]}"; do
    if [[ ! -d "$volume" ]]; then
      log WARN "Spotlight volume not found: $volume"
      continue
    fi

    if confirm "Reindex Spotlight metadata on $volume?"; then
      run_command /usr/bin/mdutil -i on "$volume"
      run_command /usr/bin/mdutil -E "$volume"
      log INFO "Triggered Spotlight reindex on $volume"
    fi
  done
}

LoggedInUser=$(stat -f%Su /dev/console)

if [[ -z "$LoggedInUser" || "$LoggedInUser" == "loginwindow" ]]; then
  log ERROR "No logged-in user detected."
  exit 1
fi

DRY_RUN=false
ASSUME_YES=false
CLEAR_USER_CACHES=false
CLEAR_SAVED_STATE=false
ROTATE_LOGS=false
REINDEX_SPOTLIGHT=false
declare -a SPOTLIGHT_VOLUMES=()
declare -a APP_CACHE_TARGETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--clear-user-caches)
      CLEAR_USER_CACHES=true
      ;;
    -s|--clear-saved-state)
      CLEAR_SAVED_STATE=true
      ;;
    -l|--rotate-logs)
      ROTATE_LOGS=true
      ;;
    -m|--reindex-spotlight)
      REINDEX_SPOTLIGHT=true
      ;;
    --spotlight-volume)
      if [[ $# -lt 2 ]]; then
        log ERROR "--spotlight-volume requires a path argument"
        exit 1
      fi
      SPOTLIGHT_VOLUMES+=("$2")
      shift
      ;;
    -a|--app-cache)
      if [[ $# -lt 2 ]]; then
        log ERROR "--app-cache requires an identifier"
        exit 1
      fi
      APP_CACHE_TARGETS+=("$2")
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    -y|--yes)
      ASSUME_YES=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log ERROR "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

if ! $CLEAR_USER_CACHES && ! $CLEAR_SAVED_STATE && ! $ROTATE_LOGS && \
   ! $REINDEX_SPOTLIGHT && [[ ${#APP_CACHE_TARGETS[@]} -eq 0 ]]; then
  log ERROR "No maintenance actions selected."
  usage
  exit 1
fi

USER_HOME="/Users/$LoggedInUser"

if $CLEAR_USER_CACHES; then
  remove_directory_contents "$USER_HOME/Library/Caches"
fi

if $CLEAR_SAVED_STATE; then
  remove_directory_contents "$USER_HOME/Library/Saved Application State"
fi

if [[ ${#APP_CACHE_TARGETS[@]} -gt 0 ]]; then
  for identifier in "${APP_CACHE_TARGETS[@]}"; do
    remove_directory_contents "$USER_HOME/Library/Caches/$identifier"
  done
fi

if $ROTATE_LOGS; then
  rotate_logs
fi

if $REINDEX_SPOTLIGHT; then
  reindex_spotlight "${SPOTLIGHT_VOLUMES[@]}"
fi

log INFO "Mac tune-up complete."
