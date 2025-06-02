# 0 = sepolia
# 1, 2 = pp
# 3 = fep
# 5 = pp custom gas token

# GAS TOKEN BRIDGE TEST
# 0 -> 1
# 1 -> 3
# 3 -> 5
# 5 -> 2
# 2 -> 0

# ETH BRIDGE TEST
# 0 -> 1
# 0 -> 5
# 1 -> 5
# 5 -> 0
# 5 -> 2
# 2 -> 0

N0_RPC=$SEPOLIA_PROVIDER
N1_RPC=http://localhost:8545  # rollupid 1, pp
N2_RPC=http://localhost:8547  # rollupid 2, pp
N3_RPC=http://localhost:8548  # rollupid 3, fep
N5_RPC=http://localhost:8550  # rollupid 5, pp custom gas token

GAS_TOKEN_ADDR=0xfA72Bea4184bBF0c567b09d457A5c6cB664254a7

INIT_FUNDED_KEY=$SEPOLIA_FUNDED_KEY
BRIDGE_ADDR=$BRIDGE_ADDR
L2FUNDED_KEY=$L2FUNDED_KEY


# token_balance <token_addr> <holder_addr> <rpc_url> <native>
token_balance() {
    local token_addr=$1
    local holder_addr=$2
    local rpc_url=$3
    local native=$4 # 1 if token is native, 0 if not

    if [[ $native -eq 1 ]]; then
        echo $(cast balance --rpc-url $rpc_url $holder_addr)
    else
        # check contract has code
        if [[ $(cast code --rpc-url $rpc_url $token_addr) == "0x" ]]; then
            echo 0
        else
            wei_hex=$(cast call --rpc-url $rpc_url $token_addr "balanceOf(address)" $holder_addr)
            echo $(echo $wei_hex | cast to-dec)
        fi
    fi
}

# bridge_token <sender_key> <recipient_addr> <eth_amount> <bridge_addr> <source_rpc_url> <dest_rpc_url> <source_networkid> <dest_networkid> <dest_claimer_key> <source_gas_token_addr> <dest_gas_token_addr> <source_native> <dest_native>
bridge_token() {
    local sender_key=$1
    local recipient_addr=$2
    local eth_amount=$3
    local bridge_addr=$4
    local source_rpc_url=$5
    local dest_rpc_url=$6
    local source_networkid=$7
    local dest_networkid=$8
    local dest_claimer_key=$9
    local source_gas_token_addr=${10}
    local dest_gas_token_addr=${11}
    local source_native=${12} # 1 if token is native on source network, 0 if not
    local dest_native=${13} # 1 if token is native on destination network, 0 if not

    sender_addr=$(cast wallet address --private-key $sender_key)
    wei_deposit_amount=$(echo "$eth_amount" | cast to-wei)

    echo "Depositing $wei_deposit_amount (token $source_gas_token_addr) from $sender_addr to $recipient_addr for network id $dest_networkid via $bridge_addr ($source_rpc_url)"

    x_balance_before=$(token_balance $source_gas_token_addr $sender_addr $source_rpc_url $source_native)
    y_balance_before=$(token_balance $dest_gas_token_addr $recipient_addr $dest_rpc_url $dest_native)

    echo "X balance before: $x_balance_before"
    echo "Y balance before: $y_balance_before"

    # if native on source, perform standard bridge with polycli
    if [[ $source_native -eq 1 ]]; then
        echo "Bridging native token using polycli"
        polycli ulxly bridge asset \
            --value $wei_deposit_amount \
            --gas-limit 1250000 \
            --bridge-address $bridge_addr \
            --destination-address $recipient_addr \
            --destination-network $dest_networkid \
            --rpc-url $source_rpc_url \
            --private-key $sender_key \
            --chain-id $(cast chain-id --rpc-url $source_rpc_url)
    else
        echo "Approving $source_gas_token_addr for $bridge_addr"
        echo "debug: cast send --rpc-url $source_rpc_url $source_gas_token_addr \"approve(address,uint256)\" $bridge_addr $wei_deposit_amount --private-key $sender_key"
        cast send --rpc-url $source_rpc_url $source_gas_token_addr "approve(address,uint256)" \
            $bridge_addr $wei_deposit_amount \
            --private-key $sender_key

        # Deposit through cast
        echo "Calling bridgeAsset on $bridge_addr"
        # bridgeAsset(uint32 destinationNetwork,address destinationAddress,uint256 amount,address token,bool forceUpdateGlobalExitRoot,bytes permitData)
        cast send --rpc-url $source_rpc_url $bridge_addr "bridgeAsset(uint32,address,uint256,address,bool,bytes)" \
            $dest_networkid $recipient_addr $wei_deposit_amount $source_gas_token_addr true "0x" \
            --private-key $sender_key
    fi

    y_balance_after=$(token_balance $dest_gas_token_addr $recipient_addr $dest_rpc_url $dest_native)

    while [ $((y_balance_after == wei_deposit_amount)) -eq 0 ]; do
        echo "Current balance for $recipient_addr is $y_balance_after, claiming again..."
        polycli ulxly claim-everything \
            --bridge-address $bridge_addr \
            --destination-address $recipient_addr \
            --rpc-url $dest_rpc_url \
            --private-key $dest_claimer_key \
            --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080,4=http://localhost:8080,5=http://localhost:8080'

        sleep 60
        y_balance_after=$(token_balance $dest_gas_token_addr $recipient_addr $dest_rpc_url $dest_native)
    done

    x_balance_after=$(token_balance $source_gas_token_addr $sender_addr $source_rpc_url $source_native)

    echo "X balance before: $x_balance_before"
    echo "X balance after : $x_balance_after"
    echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
    echo "Y balance before: $y_balance_before"
    echo "Y balance after : $y_balance_after"
    echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"
}


#
# 0 --> 1, sepolia to PP
#
test_wallet=$(cast wallet new --json)
TEST_ADDR_1=$(echo $test_wallet | jq -r .[0].address)
TEST_KEY_1=$(echo $test_wallet | jq -r .[0].private_key)

dest_gas_token_addr_1=$(cast call --rpc-url $N1_RPC $BRIDGE_ADDR "computeTokenProxyAddress(uint32,address)" 0 $GAS_TOKEN_ADDR | cast parse-bytes32-address)

bridge_token $INIT_FUNDED_KEY $TEST_ADDR_1 1 $BRIDGE_ADDR $N0_RPC $N1_RPC 0 1 $L2FUNDED_KEY $GAS_TOKEN_ADDR $dest_gas_token_addr_1 0 0


#
# 1 --> 5, PP to PP custom gas token
#
test_wallet=$(cast wallet new --json)
TEST_ADDR_5=$(echo $test_wallet | jq -r .[0].address)
TEST_KEY_5=$(echo $test_wallet | jq -r .[0].private_key)

# test_addr_1 does not have native funds on network 1 (we just bridged a token), so we need to fund it as it will pay fees for bridging
cast send --rpc-url $N1_RPC --value 0.01ether --private-key $L2FUNDED_KEY $TEST_ADDR_1

bridge_token $TEST_KEY_1 $TEST_ADDR_5 1 $BRIDGE_ADDR $N1_RPC $N5_RPC 1 5 $L2FUNDED_KEY $dest_gas_token_addr_1 $GAS_TOKEN_ADDR 0 1






# #
# # 1 --> 3, PP to FEP
# #
# test_wallet=$(cast wallet new --json)
# TEST_ADDR_3=$(echo $test_wallet | jq -r .[0].address)
# TEST_KEY_3=$(echo $test_wallet | jq -r .[0].private_key)

# dest_gas_token_addr_3=$(cast call --rpc-url $N3_RPC $BRIDGE_ADDR "computeTokenProxyAddress(uint32,address)" 1 $dest_gas_token_addr_1 | cast parse-bytes32-address)

# # test_addr_1 does not have native funds on network 1 (we just bridged a token), so we need to fund it as it will pay fees for bridging
# cast send --rpc-url $N1_RPC --value 0.01ether --private-key $L2FUNDED_KEY $TEST_ADDR_1

# bridge_token $TEST_KEY_1 $TEST_ADDR_3 0.9 $BRIDGE_ADDR $N1_RPC $N3_RPC 1 3 $L2FUNDED_KEY $dest_gas_token_addr_1 $dest_gas_token_addr_3 0 0


# #
# # 3 --> 5, FEP to PP custom gas token
# #
# test_wallet=$(cast wallet new --json)
# TEST_ADDR_5=$(echo $test_wallet | jq -r .[0].address)
# TEST_KEY_5=$(echo $test_wallet | jq -r .[0].private_key)

# # native token on network 5
# dest_gas_token_addr_5=$(cast cast address-zero)

# # test_addr_1 does not have native funds on network 1 (we just bridged a token), so we need to fund it as it will pay fees for bridging
# cast send --rpc-url $N1_RPC --value 0.01ether --private-key $L2FUNDED_KEY $TEST_ADDR_1

# bridge_token $TEST_KEY_1 $TEST_ADDR_3 0.9 $BRIDGE_ADDR $N1_RPC $N3_RPC 1 3 $L2FUNDED_KEY $dest_gas_token_addr_1 $dest_gas_token_addr_3 0 0

