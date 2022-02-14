#!/usr/bin/env bash

set -e

# Defaults to local. NOTE you will need sops master key imported into your gpg
# installation first.
keystore_secrets_file='keystore.json'
keystore='.testing_keystore'

[[ ! -z "$1" ]] && {
    if [ -z "$2" ]; then
        echo "Must supply both secrets file (sops encrypted) + keystore directory"
        echo "E.g. ./ethaccounts.sh path/to/keystore.json path/to/alt/keystore"
        exit 1
    fi
    keystore_secrets_file="$1"
    keystore="$2"
}

[[ ! -f "$keystore_secrets_file" ]] && {
    echo "Can't continue $keystore_secrets_file does not seem to exist."
    exit 1
}

echo "Exporting Ethereum accounts from $keystore_secrets_file to $keystore."
echo "It will overwrite what's there. Ctrl+c now, or hit Enter to continue."
read

accounts=$(sops -d "$keystore_secrets_file" | jq '.accounts[] | [.filename, .contents] | join("|")' | tr -d '"')

for account in $accounts; do
    fn=$(echo "$account" | tr '|' ' ' | awk '{print $1}')
    key=$(echo "$account" | tr '|' ' ' | awk '{print $2}' | base64 -d)
    echo "$key" > "$keystore/$fn"
    echo "Wrote $keystore/$fn"
done
