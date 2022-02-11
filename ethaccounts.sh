#!/usr/bin/env bash

set -e

[[ -z "$ETH_KEYSTORE" ]] && {
    echo "ETH_KEYSTORE not set, can't continue. NOTE, you can set this to .testing_keystore"
    echo "if you'd like. It will be safe from getting committed."
    exit 1
}

[[ ! -d "$1" ]] && {
    echo "Please pass me a location to a Median deploy. Something like:"
    echo "    deploy/arbitrum-ETHUSD"
    exit 1
}

keystore_secrets_file="$1/keystore.json"

[[ ! -f "$keystore_secrets_file" ]] && {
    echo "Can't continue $keystore_secrets_file does not seem to exist."
    exit 1
}

echo "Exporting Ethereum accounts to $ETH_KEYSTORE. It will overwrite what's there."
echo "Ctrl+c now, or hit Enter to continue."
read

accounts=$(sops -d "$keystore_secrets_file" | jq '.accounts[] | [.filename, .contents] | join("|")' | tr -d '"')

for account in $accounts; do
    fn=$(echo "$account" | tr '|' ' ' | awk '{print $1}')
    key=$(echo "$account" | tr '|' ' ' | awk '{print $2}' | base64 -d)
    echo "$key" > "$ETH_KEYSTORE/$fn"
    echo "Wrote $ETH_KEYSTORE/$fn"
done
