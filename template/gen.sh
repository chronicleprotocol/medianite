#!/usr/bin/env bash

set -e

script_path=$(dirname $0)
template="$script_path/ext.sol"
make_template="$script_path/ext.Makefile"
deploy_home='deploy'
median_source='template/median'

required() {
    if [ -z "$1" ]; then
        echo "Must supply a value, exiting."
        exit 1
    fi
}

# Get necessary fields from user
read -p "Chain (e.g. ethereum, arbitrum, etc): " chain
required $chain
read -p "Pair (e.g. ETHUSD): " pair
required $pair

chain=$(echo "$chain" | tr A-Z a-z)
pair=$(echo "$pair" | tr a-z A-Z)
deploy_dir="$deploy_home/${chain}-${pair}"
if [ -d "$deploy_dir" ]; then
    echo "$deploy_dir already exists! Will not overwrite."
    echo "Delete manually and re-deploy if you want to start over."
    exit 1
fi
echo; echo "Will create a new deploy in: $deploy_dir"
read -p "Type 'ok' to continue: " ok
[[ "$ok" = "ok" ]]

# Generate deploy
mkdir -p $deploy_dir
cp -R $median_source "$deploy_dir/median"
rm -fr "$deploy_dir/median/".git*

cat "$template" | sed "s/PAIR/$pair/g" >> "$deploy_dir/median/src/median.sol"
echo; echo "Added contract extension from template:"
echo "=============================="
cat "$deploy_dir/median/src/median.sol" | tail -n $(cat "$template" | wc -l | xargs)
echo "=============================="; echo

cat "$make_template" >> "$deploy_dir/median/Makefile"
pushd "$deploy_dir/median"
make dappinit
popd

find "$deploy_dir" | grep -v '.git'
