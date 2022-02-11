#!/usr/bin/env bash

set -e

# Make sure we're not testing anything in live
chain=$(seth chain 2>/dev/null) || {
    echo "Not connected, please run:"
    echo "  dapp testnet --accounts n (where n is an odd number)"
    echo ""
    exit 1
}

[[ $chain = ethlive ]] && {
    echo "Wow, you are connected to mainnet. Exiting!"
    exit 1
}


[[ -z "$MEDIAN" ]] && {
    echo "To conitnue, you need to do"
    echo "  export MEDIAN=<Address of median contract>"
    exit 1
}

[[ -z "$PAIR" ]] && {
    echo "To conitnue, you need to do"
    echo "  export PAIR=<Currency pair>"
    echo "  E.g. export PAIR=ETHUSD"
    exit 1
}

for e in $(echo "ETH_FROM ETH_KEYSTORE ETH_PASSWORD ETH_GAS ETH_RPC_URL"); do
    [[ -z $(printenv | grep -E "^$e=") ]] && {
        echo "$e is unset. Cannot continue"
        exit 1
    }
done

ETH_RPC_ACCOUNTS=yes
printenv | grep -E '^ETH_'

function hash {
    local wat wad zzz
    
    wat=$(seth --to-bytes32 "$(seth --from-ascii "$1")")    
    wad=$(seth --to-wei "$2" eth)
    wad=$(seth --to-word "$wad")
    zzz=$(seth --to-word "$3")
    hexcat=$(echo "$wad$zzz$wat" | sed 's/0x//g')
    seth keccak "0x$hexcat"
}

function join { local IFS=","; echo "$*"; }

mapfile -t accounts < <(ethsign ls | grep -v $ETH_FROM | awk '{print $1}')

echo "Median: $MEDIAN"
echo "Sending from: $ETH_FROM"

if [ "$1" = "lift-accounts" ]; then
    for acc in "${accounts[@]}"; do
        allaccs+=("${acc#0x}")
    done
    echo "lift()ing account $acc..."
    seth send "$median" 'lift(address[] memory)' "[$(join "${allaccs[@]}")]"
    exit 0
fi

echo "Oracles signing prices..."
i=1
ts=1549168920 # dapp testnet
[[ ! -z "$AGE" ]] && {
    ts=$(date -u +"%s")
}
empty_pass='template/median/empty'
for acc in "${accounts[@]}"; do
    price=$((250 + i))
    i=$((i + 1))
    hash=$(hash "$PAIR" "$price" "$ts")
    sig=$(ETH_KEYSTORE='.testing_keystore' ethsign msg --from "$acc" --data "$hash" --passphrase-file "$empty_pass")
    res=$(sed 's/^0x//' <<< "$sig")
    r=${res:0:64}
    s=${res:64:64}
    v=${res:128:2}
    v=$(seth --to-word "0x$v")
    
    price=$(seth --to-wei "$price" eth)
    prices+=("$(seth --to-word "$price")")
    tss+=("$(seth --to-word "$ts")")
    rs+=("0x$r")
    ss+=("0x$s")
    vs+=("$v")
    # cat <<EOF
# Address: $acc
  # val: $price
  # ts : $ts
  # v  : $v
  # r  : $r
  # s  : $s
# EOF
done

allts=$(join "${tss[@]}")
allprices=$(join  "${prices[@]}")
allr=$(join "${rs[@]}")
alls=$(join "${ss[@]}")
allv=$(join "${vs[@]}")

echo "Sending tx... $ETH_FROM / $ETH_KEYSTORE"
tx=$(set -x; seth send --async "$MEDIAN" 'poke(uint256[] memory,uint256[] memory,uint8[] memory,bytes32[] memory,bytes32[] memory)' \
"[$allprices]" \
"[$allts]" \
"[$allv]" \
"[$allr]" \
"[$alls]")

echo "[$allprices]"; echo
echo "[$allts]"; echo
echo "[$allv]"; echo
echo "[$allr]"; echo
echo "[$alls]"; echo

echo "TX: $tx"
echo SUCCESS: "$(seth receipt "$tx" status)"
echo GAS USED: "$(seth receipt "$tx" gasUsed)"

# setzer peek "$MEDIAN"
