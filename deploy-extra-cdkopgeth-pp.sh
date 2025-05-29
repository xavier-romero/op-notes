#!/bin/bash
SOURCE_CONTEXT=/home/opstack/upgrade/vars.sh
[ -f "$SOURCE_CONTEXT" ] && source "$SOURCE_CONTEXT"

SUFFIX=4
WORKDIR=/home/opstack/upgrade${SUFFIX}
NETWORKNAME=upgrade${SUFFIX}
NEW_CHAINID=66778${SUFFIX}

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

save_var ZKEVM_ADMIN $ZKEVM_ADMIN
save_var ZKEVM_ADMIN_KEY $ZKEVM_ADMIN_KEY
save_var ZKEVM_ADMIN_MNEMONIC "$ZKEVM_ADMIN_MNEMONIC"
save_var WALLETS_SCRIPT ${SCRIPTDIR}/wallets.py
save_var SOURCE_RUNDIR ${RUNDIR}
save_var ZKEVM_CONTRACTS $ZKEVM_CONTRACTS
save_var SEPOLIA_PROVIDER $SEPOLIA_PROVIDER
save_var SEPOLIA_CHAINID $SEPOLIA_CHAINID
save_var SEPOLIA_FUNDED_KEY $SEPOLIA_FUNDED_KEY
save_var SEPOLIA_FUNDED_ADDR $(cast wallet address --private-key $SEPOLIA_FUNDED_KEY)
save_var INFURA_SEPOLIA_PROVIDER $INFURA_SEPOLIA_PROVIDER
save_var ROLLUPMANAGER $ROLLUPMANAGER
save_var PPVKEY_VERIFIER $PPVKEY_VERIFIER
save_var SOURCE_GENESIS ${DATA}/genesis.json
save_var POLTOKENADDR $POLTOKENADDR
save_var BRIDGE_ADDR $BRIDGE_ADDR
save_var GERMANAGER $GERMANAGER
save_var RM_BLOCKNUMBER $RM_BLOCKNUMBER
save_var AGGKITPROVER_TAG $AGGKITPROVER_TAG
save_var AGGKIT_TAG $AGGKIT_TAG
save_var AGGLAYER_TAG $AGGLAYER_TAG
save_var SUCCINCT_TAG $SUCCINCT_TAG
save_var DEPLOYBLOCKNUMBER $DEPLOYBLOCKNUMBER
save_var SOURCE_BRIDGE_CONFIG ${DATA}/bridge/bridge-config.toml
save_var SOURCE_BRIDGE_CMD "./bridge run --cfg $DATA/bridge/bridge-config.toml"
save_var CLAIMTX $CLAIMTX
save_var CLAIMTX_KEY $CLAIMTX_KEY
save_var L2FUNDED $L2FUNDED
save_var L2FUNDED_KEY $L2FUNDED_KEY
save_var SOURCE_CHAINID $CHAINID
save_var AGGLAYER_GW_ADDR $AGGLAYER_GW_ADDR
save_var SP1_NETWORK_KEY $SP1_NETWORK_KEY
save_var REPODIR $REPODIR


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

save_var KEYSTORE_PASSWORD SuperSecret


mkdir -p $RUNDIR $DATA $SCRIPTDIR
cd $WORKDIR

cp $SOURCE_GENESIS $DATA/genesis.json


echo "  ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗    ██╗    ██╗ █████╗ ██╗     ██╗     ███████╗████████╗███████╗"
echo " ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ██║    ██║██╔══██╗██║     ██║     ██╔════╝╚══██╔══╝██╔════╝"
echo " ██║     ██████╔╝█████╗  ███████║   ██║   █████╗      ██║ █╗ ██║███████║██║     ██║     █████╗     ██║   ███████╗"
echo " ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝      ██║███╗██║██╔══██║██║     ██║     ██╔══╝     ██║   ╚════██║"
echo " ╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗    ╚███╔███╔╝██║  ██║███████╗███████╗███████╗   ██║   ███████║"
echo "  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝   ╚══════╝"

python3 ${WALLETS_SCRIPT}
mv wallets.json $DATA/

save_var SEQUENCER $(jq -r .sequencer.address $DATA/wallets.json)
# save_var L2FUNDED $(jq -r .l2funded.address $DATA/wallets.json)
# save_var L2FUNDED_KEY $(jq -r .l2funded.key $DATA/wallets.json)
save_var FEERECIPIENT $(jq -r .feerecipient.address $DATA/wallets.json)
save_var OPADMIN $(jq -r .opadmin.address $DATA/wallets.json)
save_var OPADMIN_KEY $(jq -r .opadmin.key $DATA/wallets.json)
save_var BATCHER $(jq -r .batcher.address $DATA/wallets.json)
save_var BATCHER_KEY $(jq -r .batcher.key $DATA/wallets.json)
save_var PROPOSER $(jq -r .proposer.address $DATA/wallets.json)
save_var PROPOSER_KEY $(jq -r .proposer.key $DATA/wallets.json)
save_var CHALLENGER $(jq -r .challenger.address $DATA/wallets.json)
save_var UNSAFEBLOCKSIGNER $(jq -r .unsafeblocksigner.address $DATA/wallets.json)
save_var AGGSENDER $(jq -r .aggsender.address $DATA/wallets.json)
save_var AGGSENDER_KEY $(jq -r .aggsender.key $DATA/wallets.json)
save_var AGGORACLE $(jq -r .aggoracle.address $DATA/wallets.json)
save_var AGGORACLE_KEY $(jq -r .aggoracle.key $DATA/wallets.json)
# save_var CLAIMTX $(jq -r .claimtx.address $DATA/wallets.json)
# save_var CLAIMTX_KEY $(jq -r .claimtx.key $DATA/wallets.json)



echo " ██████╗ ███████╗████████╗    ██████╗ ██╗███╗   ██╗ █████╗ ██████╗ ██╗███████╗███████╗"
echo "██╔════╝ ██╔════╝╚══██╔══╝    ██╔══██╗██║████╗  ██║██╔══██╗██╔══██╗██║██╔════╝██╔════╝"
echo "██║  ███╗█████╗     ██║       ██████╔╝██║██╔██╗ ██║███████║██████╔╝██║█████╗  ███████╗"
echo "██║   ██║██╔══╝     ██║       ██╔══██╗██║██║╚██╗██║██╔══██║██╔══██╗██║██╔══╝  ╚════██║"
echo "╚██████╔╝███████╗   ██║       ██████╔╝██║██║ ╚████║██║  ██║██║  ██║██║███████╗███████║"
echo " ╚═════╝ ╚══════╝   ╚═╝       ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝"

# get all required binaries from source workdir, using a list of files
for file in aggkit-prover.${AGGKITPROVER_TAG} \
      aggkit.${AGGKIT_TAG} \
      agglayer.${AGGLAYER_TAG} \
      bridge \
      fetch-rollup-config.${SUCCINCT_TAG} \
      op-batcher \
      op-deployer \
      op-geth \
      op-node \
      op-proposer \
      op-succinct.${SUCCINCT_TAG} \
      polycli; do
    if [ -f ${SOURCE_RUNDIR}/$file ]; then
        cp ${SOURCE_RUNDIR}/$file $RUNDIR/
    else
        echo "File ${SOURCE_RUNDIR}/$file not found!"
        exit 1
    fi
done



echo " ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗    ██████╗  ██████╗ ██╗     ██╗     ██╗   ██╗██████╗ "
echo "██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ██╔══██╗██╔═══██╗██║     ██║     ██║   ██║██╔══██╗"
echo "██║     ██████╔╝█████╗  ███████║   ██║   █████╗      ██████╔╝██║   ██║██║     ██║     ██║   ██║██████╔╝"
echo "██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝      ██╔══██╗██║   ██║██║     ██║     ██║   ██║██╔═══╝ "
echo "╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗    ██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝██║     "
echo " ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     "

cd $ZKEVM_CONTRACTS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use v20.19.0


save_var AGGLAYER_VKEY $($RUNDIR/agglayer.${AGGLAYER_TAG} vkey)

# create_rollup_parameters.json
# NOTE: trustedsequencer here needs to match with the address configured for aggsender
jq --arg ZKEVMADMIN "$ZKEVM_ADMIN" \
   --arg NETWORKNAME "$NETWORKNAME" \
   --arg SEQUENCER "$AGGSENDER" \
   --arg CHAINID "$CHAINID" \
   --arg ZKEVMDEPLOYER_KEY "$ZKEVM_ADMIN_KEY" \
   --arg AGGORACLE "$AGGORACLE" \
   --arg PPVKEY "$AGGLAYER_VKEY" \
   '
   .realVerifier = true |
   .programVKey = $PPVKEY |
   .forkID = 12 |
   .adminZkEVM = $ZKEVMADMIN |
   .consensusContract = "PolygonPessimisticConsensus" |
   .networkName = $NETWORKNAME |
   .description = $NETWORKNAME |
   .trustedSequencer = $SEQUENCER |
   .chainID = $CHAINID |
   .deployerPvtKey = $ZKEVMDEPLOYER_KEY |
   .isVanillaClient = false |
   .gasTokenAddress = "0xfA72Bea4184bBF0c567b09d457A5c6cB664254a7" |
   .sovereignParams.bridgeManager = $ZKEVMADMIN |
   .sovereignParams.globalExitRootUpdater = $AGGORACLE |
   .sovereignParams.globalExitRootRemover = $AGGORACLE |
   .sovereignParams.emergencyBridgePauser = $ZKEVMADMIN |
   del(.aggchainParams)
   ' deployment/v2/create_rollup_parameters.json.example > deployment/v2/create_rollup_parameters.json
cp deployment/v2/create_rollup_parameters.json $DATA/

MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run deployment/v2/4_createRollup.ts --network sepolia 2>&1 | tee $DATA/05_create_rollup.out
save_var CREATE_ROLLUP_OUTPUT_FILE $(basename $(find deployment/v2/ -name 'create_rollup_output*' -type f -print0 | xargs -0 ls -t | head -n 1))

cp deployment/v2/${CREATE_ROLLUP_OUTPUT_FILE} $DATA/
save_var ROLLUPID $(cat $DATA/$CREATE_ROLLUP_OUTPUT_FILE | jq -r '.rollupID')


echo " ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗     ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗"
echo "██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝"
echo "██║     ██████╔╝█████╗  ███████║   ██║   █████╗      ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗"
echo "██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝      ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║"
echo "╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗    ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║"
echo " ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝     ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝"

jq --arg ZKEVMADMIN "$ZKEVM_ADMIN" \
   --arg CHAINID "$CHAINID" \
   --arg ZKEVMDEPLOYER_KEY "$ZKEVM_ADMIN_KEY" \
   --arg L2FUNDED "$L2FUNDED" \
   --arg ROLLUPMAN "$ROLLUPMANAGER" \
   --arg ROLLUPID $ROLLUPID \
   '
   .rollupManagerAddress = $ROLLUPMAN |
   .rollupID = $ROLLUPID |
   .chainID = $CHAINID |
   .bridgeManager = $ZKEVMADMIN |
   .globalExitRootUpdater = $ZKEVMADMIN |
   .globalExitRootRemover = $ZKEVMADMIN |
   .timelockParameters.adminAddress = $ZKEVMADMIN |
   .setPreMintAccounts = true |
   .preMintAccounts[0].address = $L2FUNDED |
   .preMintAccounts[0].balance = "1000000000000000000000000"
   ' tools/createSovereignGenesis/create-genesis-sovereign-params.json.example > tools/createSovereignGenesis/create-genesis-sovereign-params.json
cp tools/createSovereignGenesis/create-genesis-sovereign-params.json $DATA/
cp $SOURCE_GENESIS tools/createSovereignGenesis/genesis-base.json

MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER  npx hardhat run ./tools/createSovereignGenesis/create-sovereign-genesis.ts --network sepolia 2>&1 | tee $DATA/06_create-sovereign-genesis.out

save_var SOVEREIGN_GENESIS_FILE $(basename $(find tools/createSovereignGenesis/genesis-rollup* -type f -print0 | xargs -0 ls -t | head -n 1))
save_var OUTPUT_ROLLUPID_FILE $(basename $(find tools/createSovereignGenesis/output-rollup* -type f -print0 | xargs -0 ls -t | head -n 1))

cp tools/createSovereignGenesis/$SOVEREIGN_GENESIS_FILE $DATA/
cp tools/createSovereignGenesis/$SOVEREIGN_GENESIS_FILE $DATA/zkevm_allocs.json
cp tools/createSovereignGenesis/$OUTPUT_ROLLUPID_FILE $DATA/



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

# opadmin needs some funds to deploy
cast send --rpc-url $SEPOLIA_PROVIDER --value 2ether --private-key $SEPOLIA_FUNDED_KEY $OPADMIN

# APPLY, HERE THE OP CONTRACT DEPLOYMENT HAPPENS
./op-deployer apply \
  --workdir $DATA/opdeploy \
  --l1-rpc-url $INFURA_SEPOLIA_PROVIDER \
  --private-key $OPADMIN_KEY \
  --deployment-target live \
  --predeployed-file $DATA/zkevm_allocs.json 2>&1 | tee $DATA/opdeployer_apply.out

# Get genesis and rollup files
./op-deployer inspect genesis --workdir $DATA/opdeploy --outfile $DATA/opdeploy/genesis.json $CHAINID
./op-deployer inspect rollup --workdir $DATA/opdeploy --outfile $DATA/opdeploy/rollup.json $CHAINID

# Initialize geth
./op-geth init --state.scheme=hash --datadir=datadir $DATA/opdeploy/genesis.json

# run geth
CMD="${RUNDIR}/op-geth \
  --datadir ${RUNDIR}/datadir \
  --http \
  --http.corsdomain="*" \
  --http.vhosts="*" \
  --http.addr=0.0.0.0 \
  --http.port=$((SUFFIX+8545)) \
  --http.api=admin,engine,net,eth,web3,debug,miner,txpool \
  --ws \
  --ws.addr=0.0.0.0 \
  --ws.port=$((SUFFIX+8400)) \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine \
  --syncmode=full \
  --gcmode=archive \
  --nodiscover \
  --maxpeers=0 \
  --networkid=$CHAINID \
  --authrpc.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=$((SUFFIX+8551)) \
  --authrpc.jwtsecret=${RUNDIR}/jwt.txt \
  --rpc.allow-unprotected-txs \
  --rollup.disabletxpoolgossip=true \
  --miner.gaslimit=90000000 \
  --port=$((SUFFIX+30303))"

tmux new-session -d -s "opgeth_${SUFFIX}"
tmux send-keys -t "opgeth_${SUFFIX}" "$CMD" C-m

# Rollup.json is set to a wrong l1 hash for some unknown reason right now, fix it
save_var ROLLUP_JSON ${DATA}/opdeploy/rollup.json
save_var L1_BLOCK_HASH $(cast block --rpc-url $SEPOLIA_PROVIDER $(jq -r '.genesis.l1.number' $ROLLUP_JSON) --json | jq -r '.hash')
# https://github.com/ethereum-optimism/optimism/releases/tag/op-node/v1.11.0
jq --arg L1_BLOCK_HASH "$L1_BLOCK_HASH" \
  '
  .genesis.l1.hash = $L1_BLOCK_HASH |
  .chain_op_config.eip1559Elasticity = 6 |
  .chain_op_config.eip1559Denominator = 50 |
  .chain_op_config.eip1559DenominatorCanyon = 250
  ' $ROLLUP_JSON > ${ROLLUP_JSON}.out
mv ${ROLLUP_JSON}.out $ROLLUP_JSON

sleep 5

# run op-node
CMD="${RUNDIR}/op-node \
  --l2=http://localhost:$((SUFFIX+8551)) \
  --l2.jwt-secret=${RUNDIR}/jwt.txt \
  --sequencer.enabled \
  --sequencer.l1-confs=5 \
  --verifier.l1-confs=4 \
  --rollup.config=$ROLLUP_JSON \
  --rpc.addr=0.0.0.0 \
  --rpc.port=$((SUFFIX+9545)) \
  --p2p.disable \
  --rpc.enable-admin \
  --l1=$SEPOLIA_PROVIDER \
  --l1.beacon=$SEPOLIA_PROVIDER \
  --l1.rpckind=standard \
  --safedb.path=${RUNDIR}/opnodedb"

tmux new-session -d -s "opnode_${SUFFIX}"
tmux send-keys -t "opnode_${SUFFIX}" "$CMD" C-m

sleep 10

# fund the batcher
cast send --rpc-url $SEPOLIA_PROVIDER --value 0.5ether --private-key $SEPOLIA_FUNDED_KEY $BATCHER

# run op-batcher
CMD="${RUNDIR}/op-batcher \
  --l2-eth-rpc=http://localhost:$((SUFFIX+8545)) \
  --rollup-rpc=http://localhost:$((SUFFIX+9545)) \
  --poll-interval=1s \
  --sub-safety-margin=6 \
  --num-confirmations=1 \
  --safe-abort-nonce-too-low-count=3 \
  --resubmission-timeout=30s \
  --rpc.addr=0.0.0.0 \
  --rpc.port=$((SUFFIX+3548)) \
  --rpc.enable-admin \
  --max-channel-duration=25 \
  --l1-eth-rpc=$SEPOLIA_PROVIDER \
  --private-key=$BATCHER_KEY \
  --data-availability-type=blobs \
  --throttle-block-size=400000"

tmux new-session -d -s "opbatcher_${SUFFIX}"
tmux send-keys -t "opbatcher_${SUFFIX}" "$CMD" C-m


save_var L2_RPC http://localhost:$((SUFFIX+8545))
save_var L2_NODE_RPC http://localhost:$((SUFFIX+9545))


echo " ██████╗ ██╗   ██╗███╗   ██╗     █████╗  ██████╗  ██████╗ ██╗  ██╗██╗████████╗"
echo " ██╔══██╗██║   ██║████╗  ██║    ██╔══██╗██╔════╝ ██╔════╝ ██║ ██╔╝██║╚══██╔══╝"
echo " ██████╔╝██║   ██║██╔██╗ ██║    ███████║██║  ███╗██║  ███╗█████╔╝ ██║   ██║   "
echo " ██╔══██╗██║   ██║██║╚██╗██║    ██╔══██║██║   ██║██║   ██║██╔═██╗ ██║   ██║   "
echo " ██║  ██║╚██████╔╝██║ ╚████║    ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗██║   ██║   "
echo " ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   "

cd $RUNDIR
mkdir -p $DATA/aggkit/tmp

save_var L2_BRIDGE_ADDR $(cat $DATA/$OUTPUT_ROLLUPID_FILE | jq -r '.genesisSCNames."BridgeL2SovereignChain proxy"')
save_var L2_GERMANAGER_ADDR $(cat $DATA/$OUTPUT_ROLLUPID_FILE | jq -r '.genesisSCNames."GlobalExitRootManagerL2SovereignChain proxy"')
save_var ROLLUP_ADDR $(cat $DATA/$OUTPUT_ROLLUPID_FILE | jq -r '.RollupManagerInfo.rollupData.rollupAddress')

cast wallet import --keystore-dir "${DATA}/aggkit" --private-key "$AGGSENDER_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "aggsender.keystore"
cast wallet import --keystore-dir "${DATA}/aggkit" --private-key "$AGGORACLE_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "aggoracle.keystore"



# fund aggoracle to accept GER transfer
cast send --rpc-url $L2_RPC --value 5ether --private-key $L2FUNDED_KEY $AGGORACLE

# Set GER updater/remover to AggOracle address
cast send \
  --rpc-url $L2_RPC \
  --private-key $ZKEVM_ADMIN_KEY \
  $L2_GERMANAGER_ADDR \
  'transferGlobalExitRootUpdater(address)' \
  $AGGORACLE

cast send \
  --rpc-url $L2_RPC \
  --private-key $AGGORACLE_KEY \
  $L2_GERMANAGER_ADDR \
  'acceptGlobalExitRootUpdater()'

cast send \
  --rpc-url $L2_RPC \
  --private-key $ZKEVM_ADMIN_KEY \
  $L2_GERMANAGER_ADDR \
  'transferGlobalExitRootRemover(address)' \
  $AGGORACLE

cast send \
  --rpc-url $L2_RPC \
  --private-key $AGGORACLE_KEY \
  $L2_GERMANAGER_ADDR \
  'acceptGlobalExitRootRemover()'

# checking the current set address:
# cast call $L2_GERMANAGER_ADDR 'globalExitRootUpdater()'

> ${DATA}/aggkit/aggkit-config.toml cat <<EOF
PathRWData = "$DATA/aggkit/tmp/"
L1URL="$SEPOLIA_PROVIDER"
L2URL="http://localhost:$((SUFFIX+8545))"
# GRPC port for Aggkit v0.3
# readport for Aggkit v0.2
AggLayerURL="http://localhost:4443"

ForkId = 12
ContractVersions = "banana"
IsValidiumMode = false
# set var as number, not string
NetworkID = $ROLLUPID

# This is the admin account for now
L2Coinbase =  "$ZKEVM_ADMIN"
SequencerPrivateKeyPath = ""
SequencerPrivateKeyPassword  = ""

AggregatorPrivateKeyPath = ""
AggregatorPrivateKeyPassword  = ""
SenderProofToL1Addr = ""
polygonBridgeAddr = "$BRIDGE_ADDR"

RPCURL = "http://localhost:8545"
WitnessURL = ""

rollupCreationBlockNumber = "$RM_BLOCKNUMBER"
rollupManagerCreationBlockNumber = "$RM_BLOCKNUMBER"
genesisBlockNumber = "$RM_BLOCKNUMBER"

[L1Config]
chainId = "$SEPOLIA_CHAINID"
polygonZkEVMGlobalExitRootAddress = "$GERMANAGER"
polygonRollupManagerAddress = "$ROLLUPMANAGER"
polTokenAddress = "$POLTOKENADDR"
polygonZkEVMAddress = "$ROLLUP_ADDR"

[L2Config]
GlobalExitRootAddr = "$L2_GERMANAGER_ADDR"

[Log]
Environment = "development"
Level = "info"
Outputs = ["stderr"]

[RPC]
Port = $((SUFFIX+5576))

[AggSender]
AggsenderPrivateKey = {Path = "$DATA/aggkit/aggsender.keystore", Password = "$KEYSTORE_PASSWORD"}
Mode="PessimisticProof"
BlockFinality = "FinalizedBlock"
# AggchainProofURL="localhost:4447"
RequireNoFEPBlockGap = true

[AggOracle]
BlockFinality = "FinalizedBlock"
WaitPeriodNextGER="5000ms"

[AggOracle.EVMSender]
GlobalExitRootL2 = "$L2_GERMANAGER_ADDR"

[AggOracle.EVMSender.EthTxManager]
PrivateKeys = [{Path = "$DATA/aggkit/aggoracle.keystore", Password = "$KEYSTORE_PASSWORD"}]

[AggOracle.EVMSender.EthTxManager.Etherman]
# For some weird reason that needs to be set to L2 chainid, not L1
L1ChainID = "$CHAINID"

[BridgeL2Sync]
BridgeAddr = "$L2_BRIDGE_ADDR"
BlockFinality = "FinalizedBlock"

[L1InfoTreeSync]
InitialBlock = "$RM_BLOCKNUMBER"

[Metrics]
Enabled = false
EOF

# aggoracle needs some funds
cast send --rpc-url $SEPOLIA_PROVIDER --value 0.5ether --private-key $SEPOLIA_FUNDED_KEY $AGGORACLE

CMD="$RUNDIR/aggkit.${AGGKIT_TAG} run --cfg=$DATA/aggkit/aggkit-config.toml --components=aggsender,aggoracle 2>&1 | tee $RUNDIR/aggkit.log"

tmux new-session -d -s "aggkit_${SUFFIX}"
tmux send-keys -t "aggkit_${SUFFIX}" "$CMD" C-m



echo " ██████╗ ██╗   ██╗███╗   ██╗    ██████╗ ██████╗ ██╗██████╗  ██████╗ ███████╗"
echo " ██╔══██╗██║   ██║████╗  ██║    ██╔══██╗██╔══██╗██║██╔══██╗██╔════╝ ██╔════╝"
echo " ██████╔╝██║   ██║██╔██╗ ██║    ██████╔╝██████╔╝██║██║  ██║██║  ███╗█████╗  "
echo " ██╔══██╗██║   ██║██║╚██╗██║    ██╔══██╗██╔══██╗██║██║  ██║██║   ██║██╔══╝  "
echo " ██║  ██║╚██████╔╝██║ ╚████║    ██████╔╝██║  ██║██║██████╔╝╚██████╔╝███████╗"
echo " ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝  ╚═════╝ ╚══════╝"

# mkdir $DATA/bridge
# save_var BRIDGE_USER sovereign_bridge_user
# save_var BRIDGE_PASS TopSecret
# save_var BRIDGE_DB sovereign_bridge_db


# postgres required by bridge
# docker stop bridge_postgres_$SUFFIX
# docker rm bridge_postgres_$SUFFIX
# docker run --name bridge_postgres_$SUFFIX \
#   -e POSTGRES_USER=$BRIDGE_USER \
#   -e POSTGRES_PASSWORD=$BRIDGE_PASS \
#   -e POSTGRES_DB=$BRIDGE_DB \
#   -p $((SUFFIX+5432)):5432 \
#   -d postgres:15

# keystore
# cast wallet import --keystore-dir "${DATA}/bridge" --private-key "$CLAIMTX_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "claimtx.keystore"

# send l2 funds to claimtx
cast send --rpc-url $L2_RPC --value 10ether --private-key $L2FUNDED_KEY $CLAIMTX


# > ${DATA}/bridge/bridge-config.toml cat <<EOF
# [Log]
# Level = "info"
# Environment = "development"
# Outputs = ["stderr"]

# [SyncDB]
# Database = "postgres"
#   [SyncDB.PgStorage]
#   User = "$BRIDGE_USER"
#   Name = "$BRIDGE_DB"
#   Password = "$BRIDGE_PASS"
#   Host = "localhost"
#   Port = "$((SUFFIX+5432))"
#   MaxConns = 20

# [Etherman]
# l1URL = "$SEPOLIA_PROVIDER"
# L2URLs = ["http://localhost:$((SUFFIX+8545))"]

# [Synchronizer]
# SyncInterval = "5s"
# SyncChunkSize = 100

# [BridgeController]
# Store = "postgres"
# Height = 32

# [BridgeServer]
# GRPCPort = "$((SUFFIX+9090))"http://localhost:9545
# [BridgeServer.DB]
# Database = "postgres"
#   [BridgeServer.DB.PgStorage]
#   User = "$BRIDGE_USER"
#   Name = "$BRIDGE_DB"
#   Password = "$BRIDGE_PASS"
#   Host = "localhost"
#   Port = "$((SUFFIX+5432))"
#   MaxConns = 20

# [NetworkConfig]
# GenBlockNumber = "$DEPLOYBLOCKNUMBER"
# PolygonBridgeAddress = "$BRIDGE_ADDR"
# PolygonZkEVMGlobalExitRootAddress = "$GERMANAGER"
# PolygonRollupManagerAddress = "$ROLLUPMANAGER"
# # PolygonZkEVMAddress = "$ROLLUP_ADDR"
# L2PolygonBridgeAddresses = ["$L2_BRIDGE_ADDR"]
# RequireSovereignChainSmcs = [true]
# L2PolygonZkEVMGlobalExitRootAddresses = ["$L2_GERMANAGER_ADDR"]

# [ClaimTxManager]
# FrequencyToMonitorTxs = "5s"
# PrivateKey = {Path = "$DATA/bridge/claimtx.keystore", Password = "$KEYSTORE_PASSWORD"}
# Enabled = true
# RetryInterval = "1s"
# RetryNumber = 10

# [Metrics]http://localhost:9545
# cd $RUNDIR
# CMD="./bridge run --cfg $DATA/bridge/bridge-config.toml"
# tmux new-session -d -s "bridge_${SUFFIX}"
# tmux send-keys -t "bridge_${SUFFIX}" "$CMD" C-m



sed -i -E "s#(L2URLs = \[.*)(\])#\1, \"${L2_RPC}\"\2#" $SOURCE_BRIDGE_CONFIG
sed -i -E "s#(RequireSovereignChainSmcs = \[.*)(\])#\1, true\2#" $SOURCE_BRIDGE_CONFIG
sed -i -E "s#(L2PolygonZkEVMGlobalExitRootAddresses = \[.*)(\])#\1, \"${L2_GERMANAGER_ADDR}\"\2#" $SOURCE_BRIDGE_CONFIG
sed -i -E "s#(L2PolygonBridgeAddresses = \[.*)(\])#\1, \"${L2_BRIDGE_ADDR}\"\2#" $SOURCE_BRIDGE_CONFIG

tmux send-keys -t "bridge" C-c
tmux send-keys -t "bridge" "$SOURCE_BRIDGE_CMD" C-m




echo " ██████╗  ██████╗ ███╗   ██╗███████╗██╗"
echo " ██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║"
echo " ██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║"
echo " ██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝"
echo " ██████╔╝╚██████╔╝██║ ╚████║███████╗██╗"
echo " ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝"




echo " ████████╗███████╗███████╗████████╗██╗███╗   ██╗ ██████╗ "
echo " ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝ "
echo "    ██║   █████╗  ███████╗   ██║   ██║██╔██╗ ██║██║  ███╗"
echo "    ██║   ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██║   ██║"
echo "    ██║   ███████╗███████║   ██║   ██║██║ ╚████║╚██████╔╝"
echo "    ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝"

echo "██╗     ██╗      ██╗    ██╗      ██╗     ██████╗ "
echo "██║    ███║     ██╔╝    ╚██╗     ██║     ╚════██╗"
echo "██║    ╚██║    ██╔╝█████╗╚██╗    ██║      █████╔╝"
echo "██║     ██║    ╚██╗╚════╝██╔╝    ██║     ██╔═══╝ "
echo "███████╗██║     ╚██╗    ██╔╝     ███████╗███████╗"
echo "╚══════╝╚═╝      ╚═╝    ╚═╝      ╚══════╝╚══════╝"

deposit_amount="0.01ether"
wei_deposit_amount=$(echo "$deposit_amount" | sed 's/ether//g' | cast to-wei)
 
l1_balance_before=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_before=$(cast balance --rpc-url $L2_RPC $SEPOLIA_FUNDED_ADDR)

# Deposit on L1
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --destination-network $ROLLUPID \
    --rpc-url $SEPOLIA_PROVIDER \
    --private-key $SEPOLIA_FUNDED_KEY \
    --chain-id $SEPOLIA_CHAINID

sleep 1500

# Claim * on L2
$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --rpc-url $L2_RPC \
    --private-key $CLAIMTX_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080'

l1_balance_after=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_after=$(cast balance --rpc-url $L2_RPC $SEPOLIA_FUNDED_ADDR)
echo "L1 balance before: $l1_balance_before"
echo "L1 balance after : $l1_balance_after"
echo "L1 Balance diff  : $(echo "$l1_balance_after - $l1_balance_before" | bc)"
echo "L2 balance before: $l2_balance_before"
echo "L2 balance after : $l2_balance_after"
echo "L2 Balance diff  : $(echo "$l2_balance_after - $l2_balance_before" | bc)"


#
# The other way around
#

l1_balance_before=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_before=$(cast balance --rpc-url $L2_RPC $SEPOLIA_FUNDED_ADDR)

# Deposit on L2
$RUNDIR/polycli ulxly bridge asset \
    --value 1 \
    --gas-limit 1250000 \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --destination-network 0 \
    --rpc-url $L2_RPC \
    --private-key $SEPOLIA_FUNDED_KEY \
    --chain-id $CHAINID

sleep 1500

# Claim * on L1
$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --rpc-url $SEPOLIA_PROVIDER \
    --private-key $SEPOLIA_FUNDED_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080'

l1_balance_after=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_after=$(cast balance --rpc-url $L2_RPC $SEPOLIA_FUNDED_ADDR)
echo "L1 balance before: $l1_balance_before"
echo "L1 balance after : $l1_balance_after"
echo "L1 Balance diff  : $(echo "$l1_balance_after - $l1_balance_before" | bc)"
echo "L2 balance before: $l2_balance_before"
echo "L2 balance after : $l2_balance_after"
echo "L2 Balance diff  : $(echo "$l2_balance_after - $l2_balance_before" | bc)"



echo " ████████╗███████╗███████╗████████╗██╗███╗   ██╗ ██████╗ "
echo " ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝ "
echo "    ██║   █████╗  ███████╗   ██║   ██║██╔██╗ ██║██║  ███╗"
echo "    ██║   ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██║   ██║"
echo "    ██║   ███████╗███████║   ██║   ██║██║ ╚████║╚██████╔╝"
echo "    ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝"
echo " ██╗     ██████╗     ████████╗ ██████╗     ██╗     ██████╗ "
echo " ██║     ╚════██╗    ╚══██╔══╝██╔═══██╗    ██║     ╚════██╗"
echo " ██║      █████╔╝       ██║   ██║   ██║    ██║      █████╔╝"
echo " ██║     ██╔═══╝        ██║   ██║   ██║    ██║     ██╔═══╝ "
echo " ███████╗███████╗       ██║   ╚██████╔╝    ███████╗███████╗"
echo " ╚══════╝╚══════╝       ╚═╝    ╚═════╝     ╚══════╝╚══════╝"

save_var SOURCE_L2_RPC http://localhost:8545

deposit_amount="0.01ether"
wei_deposit_amount=$(echo "$deposit_amount" | sed 's/ether//g' | cast to-wei)
 
x_balance_before=$(cast balance --rpc-url $SOURCE_L2_RPC $L2FUNDED)
y_balance_before=$(cast balance --rpc-url $L2_RPC $L2FUNDED)

# Deposit on X
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $L2FUNDED \
    --destination-network $ROLLUPID \
    --rpc-url $SOURCE_L2_RPC \
    --private-key $L2FUNDED_KEY \
    --chain-id $SOURCE_CHAINID

sleep 1500

# Claim * on Y
$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $L2FUNDED \
    --rpc-url $L2_RPC \
    --private-key $L2FUNDED_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080'

x_balance_after=$(cast balance --rpc-url $SOURCE_L2_RPC $L2FUNDED)
y_balance_after=$(cast balance --rpc-url $L2_RPC $L2FUNDED)
echo "X balance before: $x_balance_before"
echo "X balance after : $x_balance_after"
echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
echo "Y balance before: $y_balance_before"
echo "Y balance after : $y_balance_after"
echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"


#
# The other way around
#

x_balance_before=$(cast balance --rpc-url $SOURCE_L2_RPC $L2FUNDED)
y_balance_before=$(cast balance --rpc-url $L2_RPC $L2FUNDED)

# Deposit on Y
$RUNDIR/polycli ulxly bridge asset \
    --value $wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $L2FUNDED \
    --destination-network 1 \
    --rpc-url $L2_RPC \
    --private-key $L2FUNDED_KEY \
    --chain-id $CHAINID

sleep 1500

# Claim * on X
$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $L2FUNDED \
    --rpc-url $SOURCE_L2_RPC \
    --private-key $L2FUNDED_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080,2=http://localhost:8080,3=http://localhost:8080'

x_balance_after=$(cast balance --rpc-url $SOURCE_L2_RPC $L2FUNDED)
y_balance_after=$(cast balance --rpc-url $L2_RPC $L2FUNDED)
echo "X balance before: $x_balance_before"
echo "X balance after : $x_balance_after"
echo "X Balance diff  : $(echo "$x_balance_after - $x_balance_before" | bc)"
echo "Y balance before: $y_balance_before"
echo "Y balance after : $y_balance_after"
echo "Y Balance diff  : $(echo "$y_balance_after - $y_balance_before" | bc)"

