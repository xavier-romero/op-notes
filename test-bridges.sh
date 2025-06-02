# 0 = sepolia
# 1, 2 = pp
# 3 = fep

# 0 -> 1
# 1 -> 3
# 3 -> 2
# 2 -> 0

N0_RPC=$SEPOLIA_PROVIDER
N1_RPC=http://localhost:8545  # rollupid 1
N2_RPC=http://localhost:8547  # rollupid 2
N3_RPC=http://localhost:8548  # rollupid 3

INIT_FUNDED_KEY=$SEPOLIA_FUNDED_KEY
BRIDGE_ADDR=$BRIDGE_ADDR
L2FUNDED_KEY=$L2FUNDED_KEY

#
# TRANSFER FUNCTION
#
# bridge <sender_key> <recipient_addr> <eth_amount> <bridge_addr> <source_rpc_url> <dest_rpc_url> <dest_networkid> <dest_claimer_key>
bridge() {
    local sender_key=$1
    local recipient_addr=$2
    local eth_amount=$3
    local bridge_addr=$4
    local source_rpc_url=$5
    local dest_rpc_url=$6
    local dest_networkid=$7
    local dest_claimer_key=$8

    sender_addr=$(cast wallet address --private-key $sender_key)
    wei_deposit_amount=$(echo "$eth_amount" | cast to-wei)

    echo "Depositing $wei_deposit_amount from $sender_addr to $recipient_addr for network id $dest_networkid via $bridge_addr ($source_rpc_url)"

    x_balance_before=$(cast balance --rpc-url $source_rpc_url $sender_addr)
    y_balance_before=$(cast balance --rpc-url $dest_rpc_url $recipient_addr)

    # Deposit
    polycli ulxly bridge asset \
        --value $wei_deposit_amount \
        --gas-limit 1250000 \
        --bridge-address $bridge_addr \
        --destination-address $recipient_addr \
        --destination-network $dest_networkid \
        --rpc-url $source_rpc_url \
        --private-key $sender_key \
        --chain-id $(cast chain-id --rpc-url $source_rpc_url)

    y_balance_after=$(cast balance --rpc-url $dest_rpc_url $recipient_addr)

    while [ $((y_balance_after == wei_deposit_amount)) -eq 0 ]; do
        echo "Current balance for $recipient_addr is $y_balance_after, claiming again..."
        polycli ulxly claim-everything \
            --bridge-address $bridge_addr \
            --destination-address $recipient_addr \
            --rpc-url $dest_rpc_url \
            --private-key $dest_claimer_key \
            --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080,4=http://localhost:8080,5=http://localhost:8080'

        sleep 60
        y_balance_after=$(cast balance --rpc-url $dest_rpc_url $recipient_addr)
    done

    x_balance_after=$(cast balance --rpc-url $source_rpc_url $sender_addr)

    echo "X balance before: $x_balance_before"
    echo "X balance after : $x_balance_after"
    echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
    echo "Y balance before: $y_balance_before"
    echo "Y balance after : $y_balance_after"
    echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"
}

#
# 0 --> 1
#
test_wallet=$(cast wallet new --json)
TEST_ADDR_1=$(echo $test_wallet | jq -r .[0].address)
TEST_KEY_1=$(echo $test_wallet | jq -r .[0].private_key)

bridge $INIT_FUNDED_KEY $TEST_ADDR_1 0.01 $BRIDGE_ADDR $N0_RPC $N1_RPC 1 $L2FUNDED_KEY

#
# 1 --> 3
#
test_wallet=$(cast wallet new --json)
TEST_ADDR_3=$(echo $test_wallet | jq -r .[0].address)
TEST_KEY_3=$(echo $test_wallet | jq -r .[0].private_key)

bridge $TEST_KEY_1 $TEST_ADDR_3 0.009 $BRIDGE_ADDR $N1_RPC $N3_RPC 3 $L2FUNDED_KEY

#
# 3 --> 2
#
test_wallet=$(cast wallet new --json)
TEST_ADDR_2=$(echo $test_wallet | jq -r .[0].address)
TEST_KEY_2=$(echo $test_wallet | jq -r .[0].private_key)

bridge $TEST_KEY_3 $TEST_ADDR_2 0.008 $BRIDGE_ADDR $N3_RPC $N2_RPC 2 $L2FUNDED_KEY


#
# 2 --> 0
#
test_wallet=$(cast wallet new --json)
TEST_ADDR_0=$(echo $test_wallet | jq -r .[0].address)
TEST_KEY_0=$(echo $test_wallet | jq -r .[0].private_key)

bridge $TEST_KEY_2 $TEST_ADDR_0 0.007 $BRIDGE_ADDR $N2_RPC $N0_RPC 0 $INIT_FUNDED_KEY








x_balance_before=$(cast balance --rpc-url $N0_RPC $TEST_ADDR)
y_balance_before=$(cast balance --rpc-url $N1_RPC $TEST_ADDR)

deposit_amount="0.05ether" && wei_deposit_amount=$(echo "$deposit_amount" | sed 's/ether//g' | cast to-wei)

# Deposit on N0
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $TEST_ADDR \
    --destination-network 1 \
    --rpc-url $N0_RPC \
    --private-key $SEPOLIA_FUNDED_KEY \
    --chain-id $(cast chain-id --rpc-url $N0_RPC)

x_balance_after=$(cast balance --rpc-url $N0_RPC $TEST_ADDR)
y_balance_after=$(cast balance --rpc-url $N1_RPC $TEST_ADDR)
echo "X balance before: $x_balance_before"
echo "X balance after : $x_balance_after"
echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
echo "Y balance before: $y_balance_before"
echo "Y balance after : $y_balance_after"
echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"


#
# 1 --> 3
#

x_balance_before=$(cast balance --rpc-url $N1_RPC $TEST_ADDR)
y_balance_before=$(cast balance --rpc-url $N3_RPC $TEST_ADDR)

deposit_amount="0.04ether" && wei_deposit_amount=$(echo "$deposit_amount" | sed 's/ether//g' | cast to-wei)

# Deposit on N1
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $TEST_ADDR \
    --destination-network 3 \
    --rpc-url $N1_RPC \
    --private-key $TEST_KEY \
    --chain-id $(cast chain-id --rpc-url $N1_RPC)

# 9:24AM INF bridgeTxn: 0xa8f39431d0086d305f214ac60f12f38c8ed31050efc57447ae8f4b05167de7ca
# 9:24AM INF transaction successful txHash=0xa8f39431d0086d305f214ac60f12f38c8ed31050efc57447ae8f4b05167de7ca
# cast tx --rpc-url $N1_RPC 0xa8f39431d0086d305f214ac60f12f38c8ed31050efc57447ae8f4b05167de7ca

x_balance_after=$(cast balance --rpc-url $N1_RPC $TEST_ADDR)
y_balance_after=$(cast balance --rpc-url $N3_RPC $TEST_ADDR)
echo "X balance before: $x_balance_before"
echo "X balance after : $x_balance_after"
echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
echo "Y balance before: $y_balance_before"
echo "Y balance after : $y_balance_after"
echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"

# $RUNDIR/polycli ulxly claim-everything \
#     --bridge-address $L2_BRIDGE_ADDR \
#     --destination-address $TEST_ADDR \
#     --rpc-url $L2_RPC \
#     --private-key $CLAIMTX_KEY \
#     --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080,4=http://localhost:8080'


#
# 3 --> 2
#

x_balance_before=$(cast balance --rpc-url $N3_RPC $TEST_ADDR)
y_balance_before=$(cast balance --rpc-url $N2_RPC $TEST_ADDR)

deposit_amount="0.001ether" && wei_deposit_amount=$(echo "$deposit_amount" | sed 's/ether//g' | cast to-wei)

# Deposit on N1
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $TEST_ADDR \
    --destination-network 2 \
    --rpc-url $N3_RPC \
    --private-key $TEST_KEY \
    --chain-id $(cast chain-id --rpc-url $N3_RPC)

# 7:04AM INF bridgeTxn: 0x37e676f5c4b42362c13c5769d7601f81e6476b6679db27c55e9acd693c07798d
# 7:04AM INF transaction successful txHash=0x37e676f5c4b42362c13c5769d7601f81e6476b6679db27c55e9acd693c07798d

x_balance_after=$(cast balance --rpc-url $N3_RPC $TEST_ADDR)
y_balance_after=$(cast balance --rpc-url $N2_RPC $TEST_ADDR)
echo "X balance before: $x_balance_before"
echo "X balance after : $x_balance_after"
echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
echo "Y balance before: $y_balance_before"
echo "Y balance after : $y_balance_after"
echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"

# $RUNDIR/polycli ulxly claim-everything \
#     --bridge-address $L2_BRIDGE_ADDR \
#     --destination-address $TEST_ADDR \
#     --rpc-url $N2_RPC \
#     --private-key $CLAIMTX_KEY \
#     --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080,4=http://localhost:8080'


#
# 2 --> 0
#

x_balance_before=$(cast balance --rpc-url $N2_RPC $TEST_ADDR)
y_balance_before=$(cast balance --rpc-url $N0_RPC $TEST_ADDR)

deposit_amount="0.02ether" && wei_deposit_amount=$(echo "$deposit_amount" | sed 's/ether//g' | cast to-wei)

# Deposit on N0
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $TEST_ADDR \
    --destination-network 0 \
    --rpc-url $N2_RPC \
    --private-key $TEST_KEY \
    --chain-id $(cast chain-id --rpc-url $N2_RPC)

# 8:53AM INF bridgeTxn: 0xfcf318e6be5b8686739494776202f32c6ad85c37f64e5314de0ffcd4f0a3806a
# 8:53AM INF transaction successful txHash=0xfcf318e6be5b8686739494776202f32c6ad85c37f64e5314de0ffcd4f0a3806a

x_balance_after=$(cast balance --rpc-url $N2_RPC $TEST_ADDR)
y_balance_after=$(cast balance --rpc-url $N0_RPC $TEST_ADDR)
echo "X balance before: $x_balance_before"
echo "X balance after : $x_balance_after"
echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
echo "Y balance before: $y_balance_before"
echo "Y balance after : $y_balance_after"
echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"

$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $TEST_ADDR \
    --rpc-url $N0_RPC \
    --private-key $SEPOLIA_FUNDED_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080,4=http://localhost:8080'
