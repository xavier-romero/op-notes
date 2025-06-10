#!/bin/bash
SOURCE_CONTEXT=/home/opstack/upgrade/vars.sh
[ -f "$SOURCE_CONTEXT" ] && source "$SOURCE_CONTEXT"

SUFFIX=3
WORKDIR=/home/opstack/isolated${SUFFIX}
NETWORKNAME=isolated${SUFFIX}
NEW_CHAINID=77889${SUFFIX}


echo " ██╗   ██╗ █████╗ ██████╗ ███████╗   ███████╗██╗  ██╗"
echo " ██║   ██║██╔══██╗██╔══██╗██╔════╝   ██╔════╝██║  ██║"
echo " ██║   ██║███████║██████╔╝███████╗   ███████╗███████║"
echo " ╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║   ╚════██║██╔══██║"
echo "  ╚████╔╝ ██║  ██║██║  ██║███████║██╗███████║██║  ██║"
echo "   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝"
# Everything will be stored on vars.sh from now
mkdir -p $WORKDIR && cd $WORKDIR
CONTEXT_FILE=${WORKDIR}/vars.sh

> $CONTEXT_FILE cat <<EOF
# Function to save a variable and set it in the current shell
save_var() {
  local var_name="\$1"
  local var_value="\$2"

  [ -f "$CONTEXT_FILE" ] || touch "$CONTEXT_FILE"

    # Update the file: remove old var definition if exists
    grep -v "^\${var_name}=" "$CONTEXT_FILE" 2>/dev/null > "${CONTEXT_FILE}.tmp"
    echo "\${var_name}=\"\${var_value}\"" >> "${CONTEXT_FILE}.tmp"
    mv "${CONTEXT_FILE}.tmp" "$CONTEXT_FILE"

    # Set the variable in current shell
    eval "\$var_name=\"\\\$var_value\""
}
EOF

chmod +x $CONTEXT_FILE
[ -f "$CONTEXT_FILE" ] && source "$CONTEXT_FILE"


echo "███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗     ██████╗ ██████╗ ███╗   ██╗████████╗███████╗██╗  ██╗████████╗"
echo "██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝"
echo "███████╗██║   ██║██║   ██║██████╔╝██║     █████╗      ██║     ██║   ██║██╔██╗ ██║   ██║   █████╗   ╚███╔╝    ██║   "
echo "╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝      ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══╝   ██╔██╗    ██║   "
echo "███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗    ╚██████╗╚██████╔╝██║ ╚████║   ██║   ███████╗██╔╝ ██╗   ██║   "
echo "╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   "

save_var WALLETS_SCRIPT ${SCRIPTDIR}/wallets.py
save_var SOURCE_RUNDIR ${RUNDIR}
save_var SEPOLIA_PROVIDER $SEPOLIA_PROVIDER
save_var SEPOLIA_CHAINID $SEPOLIA_CHAINID
save_var SEPOLIA_FUNDED_KEY $SEPOLIA_FUNDED_KEY
save_var SEPOLIA_FUNDED_ADDR $(cast wallet address --private-key $SEPOLIA_FUNDED_KEY)
save_var INFURA_SEPOLIA_PROVIDER $INFURA_SEPOLIA_PROVIDER
save_var L2FUNDED $L2FUNDED
save_var L2FUNDED_KEY $L2FUNDED_KEY


echo "██╗   ██╗ █████╗ ██████╗ ███████╗"
echo "██║   ██║██╔══██╗██╔══██╗██╔════╝"
echo "██║   ██║███████║██████╔╝███████╗"
echo "╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║"
echo " ╚████╔╝ ██║  ██║██║  ██║███████║"
echo "  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝"

save_var WORKDIR $WORKDIR

save_var SUFFIX $SUFFIX
save_var NETWORKNAME $NETWORKNAME
save_var CHAINID $NEW_CHAINID

save_var SCRIPTDIR ${WORKDIR}/scripts
save_var RUNDIR ${WORKDIR}/run
save_var DATA ${WORKDIR}/data

mkdir -p $RUNDIR $DATA $SCRIPTDIR
cd $WORKDIR


echo "  ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗    ██╗    ██╗ █████╗ ██╗     ██╗     ███████╗████████╗███████╗"
echo " ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ██║    ██║██╔══██╗██║     ██║     ██╔════╝╚══██╔══╝██╔════╝"
echo " ██║     ██████╔╝█████╗  ███████║   ██║   █████╗      ██║ █╗ ██║███████║██║     ██║     █████╗     ██║   ███████╗"
echo " ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝      ██║███╗██║██╔══██║██║     ██║     ██╔══╝     ██║   ╚════██║"
echo " ╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗    ╚███╔███╔╝██║  ██║███████╗███████╗███████╗   ██║   ███████║"
echo "  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝   ╚══════╝"

python3 ${WALLETS_SCRIPT}
mv wallets.json $DATA/

save_var SEQUENCER $(jq -r .sequencer.address $DATA/wallets.json)
save_var FEERECIPIENT $(jq -r .feerecipient.address $DATA/wallets.json)
save_var OPADMIN $(jq -r .opadmin.address $DATA/wallets.json)
save_var OPADMIN_KEY $(jq -r .opadmin.key $DATA/wallets.json)
save_var BATCHER $(jq -r .batcher.address $DATA/wallets.json)
save_var BATCHER_KEY $(jq -r .batcher.key $DATA/wallets.json)
save_var CHALLENGER $(jq -r .challenger.address $DATA/wallets.json)
save_var UNSAFEBLOCKSIGNER $(jq -r .unsafeblocksigner.address $DATA/wallets.json)



echo " ██████╗ ███████╗████████╗    ██████╗ ██╗███╗   ██╗ █████╗ ██████╗ ██╗███████╗███████╗"
echo "██╔════╝ ██╔════╝╚══██╔══╝    ██╔══██╗██║████╗  ██║██╔══██╗██╔══██╗██║██╔════╝██╔════╝"
echo "██║  ███╗█████╗     ██║       ██████╔╝██║██╔██╗ ██║███████║██████╔╝██║█████╗  ███████╗"
echo "██║   ██║██╔══╝     ██║       ██╔══██╗██║██║╚██╗██║██╔══██║██╔══██╗██║██╔══╝  ╚════██║"
echo "╚██████╔╝███████╗   ██║       ██████╔╝██║██║ ╚████║██║  ██║██║  ██║██║███████╗███████║"
echo " ╚═════╝ ╚══════╝   ╚═╝       ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝"

# get all required binaries from source workdir, using a list of files
for file in op-batcher \
      op-deployer \
      op-geth \
      op-node \
      polycli; do
    if [ -f ${SOURCE_RUNDIR}/$file ]; then
        cp ${SOURCE_RUNDIR}/$file $RUNDIR/
    else
        echo "File ${SOURCE_RUNDIR}/$file not found!"
        exit 1
    fi
done



echo " ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗     ██████╗ ██████╗       ███████╗████████╗ █████╗  ██████╗██╗  ██╗"
echo " ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝    ██╔═══██╗██╔══██╗      ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝"
echo " ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝     ██║   ██║██████╔╝█████╗███████╗   ██║   ███████║██║     █████╔╝ "
echo " ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝      ██║   ██║██╔═══╝ ╚════╝╚════██║   ██║   ██╔══██║██║     ██╔═██╗ "
echo " ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║       ╚██████╔╝██║           ███████║   ██║   ██║  ██║╚██████╗██║  ██╗"
echo " ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝        ╚═════╝ ╚═╝           ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"

cd $RUNDIR

# Initialize network
./op-deployer init --l1-chain-id $SEPOLIA_CHAINID --l2-chain-ids $CHAINID --workdir $DATA/opdeploy

# Set our addresses on intent.toml
sed -i 's/configType = ".*"/configType = "standard-overrides"/' $DATA/opdeploy/intent.toml

sed -i 's/baseFeeVaultRecipient = ".*"/baseFeeVaultRecipient = "'$FEERECIPIENT'"/' $DATA/opdeploy/intent.toml
sed -i 's/l1FeeVaultRecipient = ".*"/l1FeeVaultRecipient = "'$FEERECIPIENT'"/' $DATA/opdeploy/intent.toml
sed -i 's/sequencerFeeVaultRecipient = ".*"/sequencerFeeVaultRecipient = "'$FEERECIPIENT'"/' $DATA/opdeploy/intent.toml

sed -i 's/l1ProxyAdminOwner = ".*"/l1ProxyAdminOwner = "'$OPADMIN'"/' $DATA/opdeploy/intent.toml
sed -i 's/l2ProxyAdminOwner = ".*"/l2ProxyAdminOwner = "'$OPADMIN'"/' $DATA/opdeploy/intent.toml
sed -i 's/systemConfigOwner = ".*"/systemConfigOwner = "'$OPADMIN'"/' $DATA/opdeploy/intent.toml

sed -i 's/unsafeBlockSigner = ".*"/unsafeBlockSigner = "'$UNSAFEBLOCKSIGNER'"/' $DATA/opdeploy/intent.toml
sed -i 's/batcher = ".*"/batcher = "'$BATCHER'"/' $DATA/opdeploy/intent.toml
sed -i 's/proposer = ".*"/proposer = "'$PROPOSER'"/' $DATA/opdeploy/intent.toml
sed -i 's/challenger = ".*"/challenger = "'$CHALLENGER'"/' $DATA/opdeploy/intent.toml

# add missing section
>> $DATA/opdeploy/intent.toml cat <<EOF

[globalDeployOverrides]
  l2BlockTime = 6
  gasLimit = 60000000
  l2OutputOracleSubmissionInterval = 180
  sequencerWindowSize = 3600
EOF

cat <<EOF > $DATA/allocs.json
{
    "$L2FUNDED": {
      "balance": "$(echo 1000000 | cast to-wei | cast to-hex)"
    }
}
EOF

# opadmin needs some funds to deploy
cast send --rpc-url $SEPOLIA_PROVIDER --value 2ether --private-key $SEPOLIA_FUNDED_KEY $OPADMIN

# APPLY, HERE THE OP CONTRACT DEPLOYMENT HAPPENS
./op-deployer apply \
  --workdir $DATA/opdeploy \
  --l1-rpc-url $INFURA_SEPOLIA_PROVIDER \
  --private-key $OPADMIN_KEY \
  --predeployed-file $DATA/allocs.json \
  --deployment-target live 2>&1 | tee $DATA/opdeployer_apply.out

# Get genesis and rollup files
./op-deployer inspect genesis --workdir $DATA/opdeploy --outfile $DATA/opdeploy/genesis.json $CHAINID
./op-deployer inspect rollup --workdir $DATA/opdeploy --outfile $DATA/opdeploy/rollup.json $CHAINID

save_var ROLLUP_JSON ${DATA}/opdeploy/rollup.json

jq '.baseFeePerGas = "0x989680"' "$DATA/opdeploy/genesis.json" > "$DATA/opdeploy/genesis.json.out"
mv $DATA/opdeploy/genesis.json.out $DATA/opdeploy/genesis.json


# Initialize geth
./op-geth init --state.scheme=hash --datadir=datadir $DATA/opdeploy/genesis.json

# run geth
CMD="${RUNDIR}/op-geth \
  --datadir ${RUNDIR}/datadir \
  --http \
  --http.corsdomain="*" \
  --http.vhosts="*" \
  --http.addr=0.0.0.0 \
  --http.port=$((SUFFIX+4545)) \
  --http.api=admin,engine,net,eth,web3,debug,miner,txpool \
  --ws \
  --ws.addr=0.0.0.0 \
  --ws.port=$((SUFFIX+4400)) \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine \
  --syncmode=full \
  --gcmode=archive \
  --nodiscover \
  --maxpeers=0 \
  --networkid=$CHAINID \
  --authrpc.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=$((SUFFIX+4551)) \
  --authrpc.jwtsecret=${RUNDIR}/jwt.txt \
  --rpc.allow-unprotected-txs \
  --rollup.disabletxpoolgossip=true \
  --miner.gaslimit=90000000 \
  --port=$((SUFFIX+34303))"

tmux new-session -d -s "opgeth_isolated_${SUFFIX}"
tmux send-keys -t "opgeth_isolated_${SUFFIX}" "$CMD" C-m
save_var L2_RPC http://localhost:$((SUFFIX+4545))

save_var L2_BLOCK_HASH $(cast block --rpc-url $L2_RPC --json 0 | jq -r .hash)
save_var L1_BLOCK_HASH $(cast block --rpc-url $SEPOLIA_PROVIDER $(jq -r '.genesis.l1.number' $ROLLUP_JSON) --json | jq -r '.hash')
# https://github.com/ethereum-optimism/optimism/releases/tag/op-node/v1.11.0
jq --arg L1_BLOCK_HASH "$L1_BLOCK_HASH" \
  --arg L2_BLOCK_HASH "$L2_BLOCK_HASH" \
  '
  .genesis.l1.hash = $L1_BLOCK_HASH |
  .genesis.l2.hash = $L2_BLOCK_HASH |
  .chain_op_config.eip1559Elasticity = 1 |
  .chain_op_config.eip1559Denominator = 5000 |
  .chain_op_config.eip1559DenominatorCanyon = 5000 |
  .genesis.system_config.gasLimit = 60000000
  ' $ROLLUP_JSON > ${ROLLUP_JSON}.out
mv ${ROLLUP_JSON}.out $ROLLUP_JSON


sleep 5

# run op-node
CMD="${RUNDIR}/op-node \
  --l2=http://localhost:$((SUFFIX+4551)) \
  --l2.jwt-secret=${RUNDIR}/jwt.txt \
  --sequencer.enabled \
  --sequencer.l1-confs=5 \
  --verifier.l1-confs=4 \
  --rollup.config=$ROLLUP_JSON \
  --rpc.addr=0.0.0.0 \
  --rpc.port=$((SUFFIX+6545)) \
  --p2p.disable \
  --rpc.enable-admin \
  --l1=$SEPOLIA_PROVIDER \
  --l1.beacon=$SEPOLIA_PROVIDER \
  --l1.rpckind=standard \
  --safedb.path=${RUNDIR}/opnodedb"

tmux new-session -d -s "opnode_isolated_${SUFFIX}"
tmux send-keys -t "opnode_isolated_${SUFFIX}" "$CMD" C-m

sleep 10

# fund the batcher
cast send --rpc-url $SEPOLIA_PROVIDER --value 0.5ether --private-key $SEPOLIA_FUNDED_KEY $BATCHER

# run op-batcher
CMD="${RUNDIR}/op-batcher \
  --l2-eth-rpc=http://localhost:$((SUFFIX+4545)) \
  --rollup-rpc=http://localhost:$((SUFFIX+6545)) \
  --poll-interval=1s \
  --sub-safety-margin=6 \
  --num-confirmations=1 \
  --safe-abort-nonce-too-low-count=3 \
  --resubmission-timeout=30s \
  --rpc.addr=0.0.0.0 \
  --rpc.port=$((SUFFIX+3648)) \
  --rpc.enable-admin \
  --max-channel-duration=25 \
  --l1-eth-rpc=$SEPOLIA_PROVIDER \
  --private-key=$BATCHER_KEY \
  --data-availability-type=blobs \
  --throttle-block-size=400000"

tmux new-session -d -s "opbatcher_isolated_${SUFFIX}"
tmux send-keys -t "opbatcher_isolated_${SUFFIX}" "$CMD" C-m



save_var L2_NODE_RPC http://localhost:$((SUFFIX+6545))



echo " ██████╗  ██████╗ ███╗   ██╗███████╗██╗"
echo " ██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║"
echo " ██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║"
echo " ██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝"
echo " ██████╔╝╚██████╔╝██║ ╚████║███████╗██╗"
echo " ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝"


cast send --rpc-url $L2_RPC --value 0.5ether --private-key $L2FUNDED_KEY $SEQUENCER
cast g --rpc-url $L2_RPC



# Looks like there are mainly 5 params related to gas price (gas fees):
# 1- baseFeePerGas in genesis.json
# 2- gasLimit in genesis.json and/or genesis.system_config.gasLimit in rollup.json
# 3- eip1559DenominatorCanyon / eip1559Denominator in rollup.json
# 4- eip1559Elasticity in rollup.json
# 5- genesis.system_config.scalar in rollup.json

# Notes:
# - genesis.json params can't be changed once the network has been initialized unless there is a hard fork of the network.
# - rollup.json params can be changed at any time, they will take effect on local opnode once restarted
#   - danger: that would break the network if there are other opnodes running, as they require the same rollup.json to avoid state mismatches.

# Then, there is a target gas per block, which apparently is calculated that way: gaslimit / eip1559Elasticity
# - Example: with a gas limit of 60M and Elasticity of 2, the target gas will be 30M
# If the used gas on current block is over target gas (congestion) gas fee goes up for the next block. If we are under target gas, gas fee goes down for next block.
# - If the network is unused, the gas fee will keep going down until it reaches 1wei. If the network is congested, the gas fee will keep going up until it reaches gasLimit.

# The gas change from block to block is computed through EIP1559 rules which are quite complicated (ref: https://dankradfeist.de/ethereum/2022/03/16/exponential-eip1559.html), however we can keep in mind these basic concepts:
# - A higher eip1559Denominator will slow down the change percentage from block to block (mainly 1/Denominator will is the % of max change)
# - A higher eip1559Elasticity implies lower gas target, so it's easier to get a block over the target -> increase gas fee for next block.
# - scalar is a multiplier for the l1 gas fee, so that if we use a custom gas token which has 50% of the value of ETH, we can set scalar to 2 to compensate l1 fees

# The baseFeePerGas is meant to be the gas fee for the first block . After that, the gas is calculated using EIP1559 rules and we could say baseFeePerGas is never taken into account again.


# So, if you want a network with low fees, that will go slowly down:
# - Set a low baseFeePerGas in genesis as starting point (set as hexadecimal weis), for instance: 0x989680 (0.01Gwei)
# - Set eip1559Elasticity to 1 (gas limit will become also the target gas)
# - Set a high eip1559Denominator, for instance: 500

# If you want to always keep fees around the starting baseFeePerGas, you can set elasticity to 2 instead (as Ethereum), that way the target gas will be 50% of limit, and then:
# - If a block uses > 50% gas, fees will go up
# - If a block uses < 50% gas, fees will go down

# More info: https://mirror.xyz/hashigo%F0%9F%94%B4.eth/sZ42ZTmmEzC99gTQ7djtkec6AOXcoJNxgLO6wpHfDXA