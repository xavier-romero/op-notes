#!/bin/bash
set -e

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <[network_ids]> <l1_rpc> <bridge_addr> <l1_funded_key>"
    echo "Example: $0 '1,2,3' 'https://rpc.example.com' '0xYourBridgeAddress' '0xYourFundedKey'"
    exit 1
fi
# Assign arguments to variables

IFS=',' read -ra NETWORKIDS <<< "$1"
L1_RPC="$2"
BRIDGE_ADDR="$3"
L1_FUNDED_KEY="$4"

DST_ADDR=$(cast wallet address --private-key $L1_FUNDED_KEY)
CHAINID=$(cast chain-id --rpc-url $L1_RPC)

while true; do
    # iterate over networkids
    for netword_id in ${NETWORKIDS[@]}; do
        echo "Bridging to network ID: $netword_id"
        polycli ulxly bridge asset \
            --value 1 \
            --gas-limit 1250000 \
            --bridge-address $BRIDGE_ADDR \
            --destination-address $DST_ADDR \
            --destination-network $netword_id \
            --rpc-url $L1_RPC \
            --private-key $L1_FUNDED_KEY \
            --chain-id $CHAINID
        sleep 60
    done
    # sleep 60
done
