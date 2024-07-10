#!/bin/bash

# base64 encoded credentials
acname=''
acpass=''

# Account name and password to test
account=$( echo "$acname" | base64 --decode )
echo "$account"
password=$( echo "$acpass" | base64 --decode )
# echo "$password"

# Check if password is correct
dscl /Local/Default authonly "$account" "$password"
password_status=$?

# Check if account has a secure token
secure_token=$(sysadminctl -secureTokenStatus "$account" 2>&1 | grep -o "Secure token is ENABLED")
token_status=$?

# Validate results
if [ $password_status -eq 0 ]; then
    echo "Password is correct for account: $account"
else
    echo "Password is incorrect for account: $account"
fi

if [ $token_status -eq 0 ]; then
    echo "Account $account has a secure token."
else
    echo "Account $account does not have a secure token."
fi