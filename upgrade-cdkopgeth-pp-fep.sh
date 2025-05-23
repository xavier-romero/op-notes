#!/bin/bash
WORKDIR=/home/opstack/upgrade
CONTEXT_FILE=${WORKDIR}/vars.sh
[ -f "$CONTEXT_FILE" ] && source "$CONTEXT_FILE"


save_var L2_RPC http://localhost:8545
save_var L2_NODE_RPC http://localhost:9545

# Reference doc from John:
# https://github.com/agglayer/e2e/blob/main/scenarios/pp-to-fep-migration/run.sh


#  █████╗ ██████╗ ██████╗     ██████╗  ██████╗ ██╗     ██╗     ██╗   ██╗██████╗     ████████╗██╗   ██╗██████╗ ███████╗
# ██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔═══██╗██║     ██║     ██║   ██║██╔══██╗    ╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝
# ███████║██║  ██║██║  ██║    ██████╔╝██║   ██║██║     ██║     ██║   ██║██████╔╝       ██║    ╚████╔╝ ██████╔╝█████╗  
# ██╔══██║██║  ██║██║  ██║    ██╔══██╗██║   ██║██║     ██║     ██║   ██║██╔═══╝        ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  
# ██║  ██║██████╔╝██████╔╝    ██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝██║            ██║      ██║   ██║     ███████╗
# ╚═╝  ╚═╝╚═════╝ ╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝            ╚═╝      ╚═╝   ╚═╝     ╚══════╝
 # This can be done at any moment, no need to stop anything

> ${DATA}/add_rollup_type.json cat <<EOF
{
    "type": "EOA",
    "consensusContract": "AggchainFEP",
    "description": "PP to FEP Test Case",
    "deployerPvtKey": "$ZKEVM_ADMIN_KEY",
    "programVKey": "$AGGLAYER_VKEY",
    "polygonRollupManagerAddress": "$ROLLUPMANAGER"
  }
EOF

cd $ZKEVM_CONTRACTS
cp ${DATA}/add_rollup_type.json $ZKEVM_CONTRACTS/tools/addRollupType/
cp ${DATA}/genesis.json $ZKEVM_CONTRACTS/tools/addRollupType/

MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run $ZKEVM_CONTRACTS/tools/addRollupType/addRollupType.ts --network sepolia 2>&1 | tee $DATA/07_add_rollup_type.out

# Get the current rollup type count and make sure that it make sense
rollup_type_count=$(cast call --rpc-url $SEPOLIA_PROVIDER $ROLLUPMANAGER 'rollupTypeCount() external view returns (uint32)')
if [[ $rollup_type_count -ne 2 ]]; then
    printf "Expected a rollup type count of 2 but got %d\n" "$rollup_type_count"
    exit 1
fi



# ███████╗██╗   ██╗ ██████╗ ██████╗██╗███╗   ██╗ ██████╗████████╗    ██████╗  ██████╗ ███████╗████████╗ ██████╗ ██████╗ ███████╗███████╗
# ██╔════╝██║   ██║██╔════╝██╔════╝██║████╗  ██║██╔════╝╚══██╔══╝    ██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝██╔════╝ ██╔══██╗██╔════╝██╔════╝
# ███████╗██║   ██║██║     ██║     ██║██╔██╗ ██║██║        ██║       ██████╔╝██║   ██║███████╗   ██║   ██║  ███╗██████╔╝█████╗  ███████╗
# ╚════██║██║   ██║██║     ██║     ██║██║╚██╗██║██║        ██║       ██╔═══╝ ██║   ██║╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  ╚════██║
# ███████║╚██████╔╝╚██████╗╚██████╗██║██║ ╚████║╚██████╗   ██║       ██║     ╚██████╔╝███████║   ██║   ╚██████╔╝██║  ██║███████╗███████║
# ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝       ╚═╝      ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
save_var PG_OPS_USER op_succinct_user
save_var PG_OPS_PASS op_succinct_password
save_var PG_OPS_DB op_succinct_db

docker stop ops_postgres
docker rm ops_postgres
docker run --name ops_postgres \
  -e POSTGRES_USER=$PG_OPS_USER \
  -e POSTGRES_PASSWORD=$PG_OPS_PASS \
  -e POSTGRES_DB=$PG_OPS_DB \
  -p 5434:5432 \
  -d postgres:15


# ███████╗████████╗ ██████╗ ██████╗     ███████╗███████╗ ██████╗ ██╗   ██╗███████╗███╗   ██╗ ██████╗██╗███╗   ██╗ ██████╗ 
# ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗    ██╔════╝██╔════╝██╔═══██╗██║   ██║██╔════╝████╗  ██║██╔════╝██║████╗  ██║██╔════╝ 
# ███████╗   ██║   ██║   ██║██████╔╝    ███████╗█████╗  ██║   ██║██║   ██║█████╗  ██╔██╗ ██║██║     ██║██╔██╗ ██║██║  ███╗
# ╚════██║   ██║   ██║   ██║██╔═══╝     ╚════██║██╔══╝  ██║▄▄ ██║██║   ██║██╔══╝  ██║╚██╗██║██║     ██║██║╚██╗██║██║   ██║
# ███████║   ██║   ╚██████╔╝██║         ███████║███████╗╚██████╔╝╚██████╔╝███████╗██║ ╚████║╚██████╗██║██║ ╚████║╚██████╔╝
# ╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚══════╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 

# check that's null:
while [[ $(cast rpc --rpc-url http://localhost:4444 interop_getLatestPendingCertificateHeader 1) != "null" ]]; do
  sleep 2
done

# Save block for latst settled certificate
TMP_VAR=$(cast rpc --rpc-url http://localhost:4444 interop_getLatestSettledCertificateHeader 1 | jq -r '.metadata'  | perl -e '$_=<>; s/^\s+|\s+$//g; s/^0x//; $_=pack("H*",$_); my ($v,$f,$o,$c)=unpack("C Q> L> L>",$_); printf "{\"v\":%d,\"f\":%d,\"o\":%d,\"c\":%d}\n", $v, $f, $o, $c' | jq '.f + .o')
# next block from the block of latest certificate
save_var L2_UPGRADE_BLOCK $((TMP_VAR+1))
save_var L2_UPGRADE_BLOCK_OUTPUTROOT $(cast rpc --rpc-url "$L2_NODE_RPC" optimism_outputAtBlock $(printf "0x%x" $L2_UPGRADE_BLOCK) | jq -r .outputRoot)
save_var L2_UPGRADE_BLOCK_TIMESTAMP $(cast block $L2_UPGRADE_BLOCK --json | jq -r .timestamp | cast to-dec)

# stop sequencing through op-node
save_var STOP_SEQUENCER_HASH $(cast rpc --rpc-url http://localhost:9545 admin_stopSequencer)
# cast rpc --rpc-url http://localhost:9545 admin_startSequencer $STOP_SEQUENCER_HASH

save_var L2_UPGRADE_BLOCK_REFERENCE $(cast bn)


# ███████╗████████╗ ██████╗ ██████╗      █████╗  ██████╗  ██████╗ ██╗  ██╗██╗████████╗
# ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔════╝ ██╔════╝ ██║ ██╔╝██║╚══██╔══╝
# ███████╗   ██║   ██║   ██║██████╔╝    ███████║██║  ███╗██║  ███╗█████╔╝ ██║   ██║   
# ╚════██║   ██║   ██║   ██║██╔═══╝     ██╔══██║██║   ██║██║   ██║██╔═██╗ ██║   ██║   
# ███████║   ██║   ╚██████╔╝██║         ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗██║   ██║   
# ╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   
# Stop AggKit and set mode to Aggchain
tmux send-keys -t "aggkit" C-c
sed -i 's/Mode="PessimisticProof"/Mode="AggchainProof"/' $DATA/aggkit/aggkit-config.toml
sed -i 's/# AggchainProofURL/AggchainProofURL/' $DATA/aggkit/aggkit-config.toml


# ███████╗███████╗████████╗ ██████╗██╗  ██╗    ██████╗  ██████╗ ██╗     ██╗     ██╗   ██╗██████╗      ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██╔════╝██║  ██║    ██╔══██╗██╔═══██╗██║     ██║     ██║   ██║██╔══██╗    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
# █████╗  █████╗     ██║   ██║     ███████║    ██████╔╝██║   ██║██║     ██║     ██║   ██║██████╔╝    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
# ██╔══╝  ██╔══╝     ██║   ██║     ██╔══██║    ██╔══██╗██║   ██║██║     ██║     ██║   ██║██╔═══╝     ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
# ██║     ███████╗   ██║   ╚██████╗██║  ██║    ██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝██║         ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
# ╚═╝     ╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝          ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ 
# run fetch-rollup-config
cd $REPODIR/op-succinct
L1_RPC=$SEPOLIA_PROVIDER \
L1_BEACON_RPC=$SEPOLIA_PROVIDER \
L2_RPC=http://localhost:8545 \
L2_NODE_RPC=http://localhost:9545 \
OP_SUCCINCT_MOCK="false" \
RUST_LOG=debug \
RUST_BACKTRACE=1 \
STARTING_BLOCK_NUMBER=$L2_UPGRADE_BLOCK \
NETWORK_RPC_URL=https://rpc.production.succinct.xyz \
AGG_PROOF_MODE=compressed \
AGGLAYER="true" \
$RUNDIR/fetch-rollup-config.$SUCCINCT_TAG
# Output:
# ${REPODIR}/op-succinct/configs/${CHAINID}.json
# ${REPODIR}/op-succinct/contracts/opsuccinctl2ooconfig.json

save_var ROLLUP_CONFIG_HASH $(jq -r .rollupConfigHash ${REPODIR}/op-succinct/contracts/opsuccinctl2ooconfig.json)
save_var AGGREGATION_VKEY $(jq -r .aggregationVkey ${REPODIR}/op-succinct/contracts/opsuccinctl2ooconfig.json)
save_var RANGE_VKEY_COMMITMENT $(jq -r .rangeVkeyCommitment ${REPODIR}/op-succinct/contracts/opsuccinctl2ooconfig.json)
save_var L2_BLOCKTIME $(jq -r .l2BlockTime ${REPODIR}/op-succinct/contracts/opsuccinctl2ooconfig.json)
save_var SUBMISSION_INTERVAL $(jq -r .submissionInterval ${REPODIR}/op-succinct/contracts/opsuccinctl2ooconfig.json)



# ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗    ██████╗  ██████╗ ██╗     ██╗     ██╗   ██╗██████╗ 
# ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    ██╔══██╗██╔═══██╗██║     ██║     ██║   ██║██╔══██╗
# ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗      ██████╔╝██║   ██║██║     ██║     ██║   ██║██████╔╝
# ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝      ██╔══██╗██║   ██║██║     ██║     ██║   ██║██╔═══╝ 
# ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗    ██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝██║     
#  ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     
 
# Create the upgrade data
upgrade_data=$(cast calldata "initAggchainManager(address)" $ZKEVM_ADMIN)

cat > ${DATA}/updateRollup.json <<EOF
{
    "type": "EOA",
    "polygonRollupManagerAddress": "$ROLLUPMANAGER",
    "deployerPvtKey": "$ZKEVM_ADMIN_KEY",
    "rollups": [
        {
            "rollupAddress": "$ROLLUP_ADDR",
            "newRollupTypeID": 2,
            "upgradeData": "$upgrade_data"
        }
    ]
}
EOF

cd $ZKEVM_CONTRACTS
cp ${DATA}/updateRollup.json $ZKEVM_CONTRACTS/tools/updateRollup/

# Execute the update rollup script
MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run $ZKEVM_CONTRACTS/tools/updateRollup/updateRollup.ts --network sepolia 2>&1 | tee $DATA/08_update_rollup.out
cp $ZKEVM_CONTRACTS/tools/updateRollup/updateRollupOutput-*.json $DATA/


# ██╗███╗   ██╗██╗████████╗██╗ █████╗ ██╗     ██╗███████╗███████╗
# ██║████╗  ██║██║╚══██╔══╝██║██╔══██╗██║     ██║╚══███╔╝██╔════╝
# ██║██╔██╗ ██║██║   ██║   ██║███████║██║     ██║  ███╔╝ █████╗  
# ██║██║╚██╗██║██║   ██║   ██║██╔══██║██║     ██║ ███╔╝  ██╔══╝  
# ██║██║ ╚████║██║   ██║   ██║██║  ██║███████╗██║███████╗███████╗
# ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚══════╝
                                                               
# ██████╗  ██████╗ ██╗     ██╗     ██╗   ██╗██████╗              
# ██╔══██╗██╔═══██╗██║     ██║     ██║   ██║██╔══██╗             
# ██████╔╝██║   ██║██║     ██║     ██║   ██║██████╔╝             
# ██╔══██╗██║   ██║██║     ██║     ██║   ██║██╔═══╝              
# ██║  ██║╚██████╔╝███████╗███████╗╚██████╔╝██║                  
# ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝                  
# THATS THE MOST CRITICAL AND CONFUSING STEP
# IF POSSIBLE, CONFIRM THIS STEP WITH PROTOCOL TEAM

# Initialize the rollup just happens once after the upgrade
# Upgrade is done on the rollup manager, however the rollup itself needs to be initialized

# REFERENCES, HELPFUL LINKS:
# https://hackmd.io/48nKAyn-QceOXTxmb2byIg?view
# https://didactic-giggle-9pqo9jg.pages.github.io/aggregation-layer/v0.3.0/FAQs/#3-vkeys-aggchain-fep
# https://didactic-giggle-9pqo9jg.pages.github.io/aggregation-layer/v0.3.0/Diagrams/#update-v020-ecdsa-to-v030-fep


save_var AGGLAYER_GW_ADDR $(jq -r .aggLayerGatewayAddress $DATA/deploy_output.json)
save_var AGGKIT_VKEY $($RUNDIR/aggkit-prover.${AGGKITPROVER_TAG} vkey)
save_var AGGKIT_VKEYSELECTOR $($RUNDIR/aggkit-prover.${AGGKITPROVER_TAG} vkey-selector)

jq \
    --arg ROLLUP_CONFIG_HASH "$ROLLUP_CONFIG_HASH" \
    --arg ZKEVM_ADMIN "$ZKEVM_ADMIN" \
    --arg ROLLUPMANAGER "$ROLLUPMANAGER" \
    --arg L2_UPGRADE_BLOCK_OUTPUTROOT "$L2_UPGRADE_BLOCK_OUTPUTROOT" \
    --arg L2_UPGRADE_BLOCK "$L2_UPGRADE_BLOCK" \
    --arg L2_UPGRADE_BLOCK_TIMESTAMP "$L2_UPGRADE_BLOCK_TIMESTAMP" \
    --arg AGGREGATION_VKEY "$AGGREGATION_VKEY" \
    --arg RANGE_VKEY_COMMITMENT "$RANGE_VKEY_COMMITMENT" \
    --arg L2_BLOCKTIME "$L2_BLOCKTIME" \
    --arg SUBMISSION_INTERVAL "$SUBMISSION_INTERVAL" \
    --arg AGGKIT_VKEY "$AGGKIT_VKEY" \
    --arg AGGKIT_VKEYSELECTOR "$AGGKIT_VKEYSELECTOR" \
    --arg SEQUENCER "$AGGSENDER" \
   '.type = "EOA" |
    .trustedSequencer = $SEQUENCER |
    .aggchainParams.initParams.l2BlockTime = ($L2_BLOCKTIME | tonumber) |
    .aggchainParams.initParams.rollupConfigHash = $ROLLUP_CONFIG_HASH |https://hackmd.io/48nKAyn-QceOXTxmb2byIg?view
# https://didactic-giggle-9pqo9jg.pages.github.io/aggregation-layer/v0.3.0/FAQs/#3-vkeys-aggchain-fep
# https://didactic-giggle-9pqo9jg.pages.github.io/aggregation-layer/v0.3.0/Diagrams/#update-v020-ecdsa-to-v030-fep

    .aggchainParams.initParams.startingOutputRoot = $L2_UPGRADE_BLOCK_OUTPUTROOT |
    .aggchainParams.initParams.startingBlockNumber = ($L2_UPGRADE_BLOCK | tonumber) |
    .aggchainParams.initParams.startingTimestamp = ($L2_UPGRADE_BLOCK_TIMESTAMP | tonumber) |
    .aggchainParams.initParams.submissionInterval = ($SUBMISSION_INTERVAL | tonumber) |
    .aggchainParams.initParams.optimisticModeManager = $ZKEVM_ADMIN |
    .aggchainParams.initParams.aggregationVkey = $AGGREGATION_VKEY |
    .aggchainParams.initParams.rangeVkeyCommitment = $RANGE_VKEY_COMMITMENT |
    .aggchainParams.aggchainManager = $ZKEVM_ADMIN |
    .aggchainParams.initOwnedAggchainVKey = $AGGKIT_VKEY |
    .aggchainParams.initAggchainVKeySelector = $AGGKIT_VKEYSELECTOR |
    .aggchainParams.vKeyManager = $ZKEVM_ADMIN |
    .aggchainParams.useDefaultGateway = true |
    .realVerifier = true |
    .rollupAdminAddress = $ZKEVM_ADMIN |
    .rollupManagerAddress = $ROLLUPMANAGER |
    .rollupTypeId = 2 |
    .consensusContractName = "AggchainFEP"
'  $DATA/create_rollup_parameters.json > $DATA/initialize_fep_rollup.json
cp $DATA/initialize_fep_rollup.json $ZKEVM_CONTRACTS/tools/initializeRollup/initialize_rollup.json

MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run tools/initializeRollup/initializeRollup.ts --network sepolia 2>&1 | tee $DATA/09_initialize_rollup.out
cp $ZKEVM_CONTRACTS/tools/initializeRollup/initialize_rollup_output_*.json $DATA


# Looks like this needs to be manually executed after the upgrade
cast send \
     --rpc-url $SEPOLIA_PROVIDER \
     --private-key $ZKEVM_ADMIN_KEY \
     $AGGLAYER_GW_ADDR \
     'addDefaultAggchainVKey(bytes4,bytes32)' \
     $AGGKIT_VKEYSELECTOR $AGGKIT_VKEY


# # thats required in case they were not properly set on initialization
# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $ROLLUP_ADDR \
#     'addOwnedAggchainVKey(bytes4,bytes32)' \
#     $AGGLAYER_VKEYSELECTOR $AGGKIT_VKEY

# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $AGGLAYER_GW_ADDR \
#     'addDefaultAggchainVKey(bytes4,bytes32)' \
#     $AGGLAYER_VKEYSELECTOR $AGGKIT_VKEY

# # to verify:
# cast call --rpc-url $SEPOLIA_PROVIDER $AGGLAYER_GW_ADDR \
#     'getDefaultAggchainVKey(bytes4)' $AGGLAYER_VKEYSELECTOR


# # Set right keys - in case fetch-rollup-config got wrong values
# cast send \
#   --private-key $ZKEVM_ADMIN_KEY \
#   --rpc-url $SEPOLIA_PROVIDER \
#   $ROLLUP_ADDR \
#   'updateAggregationVkey(bytes32)' \
#   0x00c34e1ea92b8e3708fb2213142e746caa75a01308f817af6310976012a6fe40

# cast send \
#   --private-key $ZKEVM_ADMIN_KEY \
#   --rpc-url $SEPOLIA_PROVIDER \
#   $ROLLUP_ADDR \
#   'updateRangeVkeyCommitment(bytes32)' \
#   0x35882a76205af8c12eaeea7551ff8dbc392dc2a95b0f7f31660a5468237d4434

# cast send \
#   --private-key $ZKEVM_ADMIN_KEY \
#   --rpc-url $SEPOLIA_PROVIDER \
#   $ROLLUP_ADDR \
#   'updateRollupConfigHash(bytes32)' \
#   0xea23ad551e52f31a4e9fc68e95614ebf95b9f1baa8b9a3d9d0a51e93aef14d4c

# had to remove monitord_txs to be able to start aggoracle again

# GER UPDATER HAS BEEN RESET DURING UPDATE, WE NEED TO SET IT AGAIN
# cast send \
#   --private-key $ZKEVM_ADMIN_KEY \
#   $L2_GERMANAGER_ADDR \
#   'transferGlobalExitRootUpdater(address)' \
#   $AGGORACLE

# cast send \
#   --private-key $ZKEVM_ADMIN_KEY \
#   $L2_GERMANAGER_ADDR \
#   'transferGlobalExproveritRootRemover(address)' \
#   $AGGORACLE

# # fund aggoracle to accept GER transfer
# cast send --value 5ether --private-key $L2FUNDED_KEY $AGGORACLE

# cast send \
#   --private-key $AGGORACLE_KEY \
#   $L2_GERMANAGER_ADDR \
#   'acceptGlobalExitRootUpdater()'

# cast send \
#   --private-key $AGGORACLE_KEY \
#   $L2_GERMANAGER_ADDR \
#   'acceptGlobalExitRootRemover()'



#  ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗    ██╗  ██╗███████╗██╗   ██╗███████╗
# ██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝    ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
# ██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗      █████╔╝ █████╗   ╚████╔╝ ███████╗
# ██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
# ╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗    ██║  ██╗███████╗   ██║   ███████║
#  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝    ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝

# thats how to change vkeys in case we need to, usually dues to component version upgrade

# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $AGGLAYER_GW_ADDR \
#     'addPessimisticVKeyRoute(bytes4,address,bytes32)' \
#     $AGGLAYER_VKEYSELECTOR $PPVKEY_VERIFIER $AGGLAYER_VKEY

# # Get vkey for an existing selector
# #  cast call     --rpc-url $SEPOLIA_PROVIDER     $AGGLAYER_GW_ADDR     'pessimisticVKeyRoutes(bytes4)'     0x00000001

# # add vkey for the new selector
# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $ROLLUP_ADDR \
#     'addOwnedAggchainVKey(bytes4,bytes32)' \
#     $AGGKIT_VKEYSELECTOR $AGGKIT_VKEY

# # update vkey for existing selector
# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $ROLLUP_ADDR \
#     'updateOwnedAggchainVKey(bytes4,bytes32)' \
#     $AGGKIT_VKEYSELECTOR $AGGKIT_VKEY


# # add vkey for the new selector
# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $AGGLAYER_GW_ADDR \
#     'addDefaultAggchainVKey(bytes4,bytes32)' \
#     $AGGKIT_VKEYSELECTOR $AGGKIT_VKEY

# # update vkey for existing selector
# cast send \
#     --rpc-url $SEPOLIA_PROVIDER \
#     --private-key $ZKEVM_ADMIN_KEY \
#     $AGGLAYER_GW_ADDR \
#     'updateDefaultAggchainVKey(bytes4,bytes32)' \
#     $AGGKIT_VKEYSELECTOR $AGGKIT_VKEY


# cast call \
#     --rpc-url $SEPOLIA_PROVIDER \
#     $AGGLAYER_GW_ADDR \
#     'pessimisticVKeyRoutes(bytes4)' \
#     $AGGLAYER_VKEYSELECTOR





# ███████╗██╗   ██╗ ██████╗ ██████╗██╗███╗   ██╗ ██████╗████████╗    ██████╗ ██████╗  ██████╗ ██████╗  ██████╗ ███████╗███████╗██████╗ 
# ██╔════╝██║   ██║██╔════╝██╔════╝██║████╗  ██║██╔════╝╚══██╔══╝    ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔══██╗
# ███████╗██║   ██║██║     ██║     ██║██╔██╗ ██║██║        ██║       ██████╔╝██████╔╝██║   ██║██████╔╝██║   ██║███████╗█████╗  ██████╔╝
# ╚════██║██║   ██║██║     ██║     ██║██║╚██╗██║██║        ██║       ██╔═══╝ ██╔══██╗██║   ██║██╔═══╝ ██║   ██║╚════██║██╔══╝  ██╔══██╗
# ███████║╚██████╔╝╚██████╗╚██████╗██║██║ ╚████║╚██████╗   ██║       ██║     ██║  ██║╚██████╔╝██║     ╚██████╔╝███████║███████╗██║  ██║
# ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝   ╚═╝       ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝      ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
# Run the succinct proposer
CMD="L1_RPC=$SEPOLIA_PROVIDER \
  L1_BEACON_RPC=$SEPOLIA_PROVIDER \
  L2_RPC=$L2_RPC \
  L2_NODE_RPC=$L2_NODE_RPC \
  PRIVATE_KEY=$SEPOLIA_FUNDED_KEY \
  ETHERSCAN_API_KEY= \
  VERIFIER_ADDRESS=$AGGLAYER_GW_ADDR \
  AGG_PROOF_MODE=compressed \
  L2OO_ADDRESS=$ROLLUP_ADDR \
  OP_SUCCINCT_MOCK=false \
  AGGLAYER=true \
  GRPC_ADDRESS=0.0.0.0:12345 \
  NETWORK_PRIVATE_KEY=$SP1_NETWORK_KEY \
  MAX_CONCURRENT_PROOF_REQUESTS=3 \
  MAX_CONCURRENT_WITNESS_GEN=3 \
  RANGE_PROOF_INTERVAL=800 \
  DATABASE_URL=postgres://$PG_OPS_USER:$PG_OPS_PASS@localhost:5434/$PG_OPS_DB \
  PROVER_ADDRESS=$AGGSENDER \
  METRICS_PORT=3322 \
  $RUNDIR/op-succinct.${OP_SUCCINCT_TAG} 2>&1 | tee $RUNDIR/op-succinct-proposer.log"
tmux new-session -d -s succinctproposer
tmux send-keys -t "succinctproposer" "$CMD" C-m



#  █████╗  ██████╗  ██████╗ ██╗  ██╗██╗████████╗    ██████╗ ██████╗  ██████╗ ██╗   ██╗███████╗██████╗ 
# ██╔══██╗██╔════╝ ██╔════╝ ██║ ██╔╝██║╚══██╔══╝    ██╔══██╗██╔══██╗██╔═══██╗██║   ██║██╔════╝██╔══██╗
# ███████║██║  ███╗██║  ███╗█████╔╝ ██║   ██║       ██████╔╝██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝
# ██╔══██║██║   ██║██║   ██║██╔═██╗ ██║   ██║       ██╔═══╝ ██╔══██╗██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗
# ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗██║   ██║       ██║     ██║  ██║╚██████╔╝ ╚████╔╝ ███████╗██║  ██║
# ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝       ╚═╝     ╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝
cat > ${DATA}/aggkit/aggkit-prover-config.toml <<EOF
grpc-endpoint = "0.0.0.0:4447"

[log]
level = "debug"
outputs = []
format = "json"

[telemetry]
prometheus-addr = "0.0.0.0:19093"

[shutdown]r
runtime-timeout = "5s"

[aggchain-proof-service.aggchain-proof-builder]
network-id = 1

[aggchain-proof-service.aggchain-proof-builder.primary-prover.network-prover]
proving-timeout = "5h"

[aggchain-proof-service.aggchain-proof-builder.proving-timeout]
secs = 18000
nanos = 0

[aggchain-proof-service.aggchain-proof-builder.contracts]
l1-rpc-endpoint = "$SEPOLIA_PROVIDER"
l2-execution-layer-rpc-endpoint = "http://localhost:8545"
l2-consensus-layer-rpc-endpoint = "http://localhost:9545"
polygon-rollup-manager = "$ROLLUPMANAGER"
global-exit-root-manager-v2-sovereign-chain = "$L2_GERMANAGER_ADDR"

[aggchain-proof-service.proposer-service]
l1-rpc-endpoint = "$SEPOLIA_PROVIDER"
mock = false

[aggchain-proof-service.proposer-service.client]
proposer-endpoint = "http://localhost:12345"
sp1-cluster-endpoint = "https://rpc.production.succinct.xyz"
request-timeout = 18000
proving-timeout = 18000

[primary-prover.network-prover]
proving-timeout = "5h"
EOF


CMD="PROPOSER_NETWORK_PRIVATE_KEY=$SP1_NETWORK_KEY \
  NETWORK_PRIVATE_KEY=$SP1_NETWORK_KEY \
  RUST_LOG=info,aggkit_prover=debug,prover=debug,aggchain=debug \
  RUST_BACKTRACE=1 \
  $RUNDIR/aggkit-prover.${AGGKITPROVER_TAG} run --config-path $DATA/aggkit/aggkit-prover-config.toml 2>&1 | tee $RUNDIR/aggkit-prover.log"
tmux new-session -d -s aggkitprover
tmux send-keys -t "aggkitprover" "$CMD" C-m


# ██████╗ ███████╗███████╗██╗   ██╗███╗   ███╗███████╗    ███████╗███████╗ ██████╗ ██╗   ██╗███████╗███╗   ██╗ ██████╗██╗███╗   ██╗ ██████╗ 
# ██╔══██╗██╔════╝██╔════╝██║   ██║████╗ ████║██╔════╝    ██╔════╝██╔════╝██╔═══██╗██║   ██║██╔════╝████╗  ██║██╔════╝██║████╗  ██║██╔════╝ 
# ██████╔╝█████╗  ███████╗██║   ██║██╔████╔██║█████╗      ███████╗█████╗  ██║   ██║██║   ██║█████╗  ██╔██╗ ██║██║     ██║██╔██╗ ██║██║  ███╗
# ██╔══██╗██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝      ╚════██║██╔══╝  ██║▄▄ ██║██║   ██║██╔══╝  ██║╚██╗██║██║     ██║██║╚██╗██║██║   ██║
# ██║  ██║███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗    ███████║███████╗╚██████╔╝╚██████╔╝███████╗██║ ╚████║╚██████╗██║██║ ╚████║╚██████╔╝
# ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚══════╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 

# THAT COULD BE DONE EARLIER. I'D EVEN SAY THAT WE COULD DO THE WHOLE PROCESS WITHOUT STOPPING SEQUENCER AT ALL.
# start sequencer again
cast rpc --rpc-url http://localhost:9545 admin_startSequencer $STOP_SEQUENCER_HASH



# ██╗    ██╗ █████╗ ██╗████████╗      
# ██║    ██║██╔══██╗██║╚══██╔══╝      
# ██║ █╗ ██║███████║██║   ██║         
# ██║███╗██║██╔══██║██║   ██║         
# ╚███╔███╔╝██║  ██║██║   ██║██╗██╗██╗
#  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝╚═╝╚═╝╚═╝

# Recommendation:
# Let aggkit stopped, wait until succinct-proposer proved a full span.
#   Then, make a deposit on L1 and start aggkit again.
# Note: Unsure if we NEED to restart agglayer after upgrade or not.
# Note: op-stack components does not need to be restarted.


CMD="$RUNDIR/aggkit.${AGGKIT_TAG} run --cfg=$DATA/aggkit/aggkit-config.toml --components=aggsender,aggoracle 2>&1 | tee $RUNDIR/aggkit.log"
tmux send-keys -t "aggkit" "$CMD" C-m


# docker exec -it ops_postgres  psql -U $PG_OPS_USER $PG_OPS_DB
# SQL: select id, status, req_type, mode, start_block, end_block, created_at, updated_at from requests;
# Status:
        # match value {
        #     0 => RequestStatus::Unrequested,
        #     1 => RequestStatus::WitnessGeneration,
        #     2 => RequestStatus::Execution,
        #     3 => RequestStatus::Prove,
        #     4 => RequestStatus::Complete,
        #     5 => RequestStatus::Relayed,
        #     6 => RequestStatus::Failed,
        #     7 => RequestStatus::Cancelled,
        #     _ => panic!("Invalid request status: {value}"),
        # }


# Agglayer check last certificate and remove
# cast rpc --rpc-url http://localhost:4444  interop_getLatestPendingCertificateHeader 1 | jq .
# params: networkid and height
# cast rpc --rpc-url http://localhost:4446 admin_removePendingCertificate 1 0 true
