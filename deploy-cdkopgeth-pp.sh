# let's get some basic params, or show help
if [ $# -eq 0 ]; then
  echo "Usage: $0 <sepolia_provider> <sepolia_ws_provider> <sepolia_funded_key> <sp1_network_key> <infura_sepolia_provider>"
  exit 1
fi

# these vars are sensitive so values not written inside the script
SEPOLIA_PROVIDER=$1
SEPOLIA_WS_PROVIDER=$2
SEPOLIA_FUNDED_KEY=$3
SP1_NETWORK_KEY=$4
# for a specific step on contract deployment, it looks like only Infura is reliable enough
INFURA_SEPOLIA_PROVIDER=$5

# GENERAL CONFIG && VERSIONS 
WORKDIR=/home/opstack/upgrade
NETWORKNAME=network1
CHAINID=78901
OP_NODE_TAG=op-node/v1.13.2
OP_GETH_TAG=v1.101503.4
OP_BATCHER_TAG=op-batcher/v1.12.0
OP_PROPOSER_TAG=op-proposer/v1.10.0
OP_DEPLOYER_TAG_DOCKER=xavierromero/op-deployer:v0.0.11-predeployed
AGGLAYER_TAG=v0.3.0
AGGKIT_TAG=v0.3.0
AGGKITPROVER_TAG=v1.0.0
OP_SUCCINCT_TAG_DOCKER=ghcr.io/agglayer/op-succinct/op-succinct:v2.2.1-agglayer
BRIDGE_TAG=v0.6.0-RC16
ZKEVM_CONTRACTS_TAG=v10.1.0-rc.6


# ██████╗  ██████╗     ███╗   ██╗ ██████╗ ████████╗     ██████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗                   
# ██╔══██╗██╔═══██╗    ████╗  ██║██╔═══██╗╚══██╔══╝    ██╔════╝██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔════╝                   
# ██║  ██║██║   ██║    ██╔██╗ ██║██║   ██║   ██║       ██║     ███████║███████║██╔██╗ ██║██║  ███╗█████╗                     
# ██║  ██║██║   ██║    ██║╚██╗██║██║   ██║   ██║       ██║     ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══╝                     
# ██████╔╝╚██████╔╝    ██║ ╚████║╚██████╔╝   ██║       ╚██████╗██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████╗                   
# ╚═════╝  ╚═════╝     ╚═╝  ╚═══╝ ╚═════╝    ╚═╝        ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝                   
                                                                                                                           
# ███████╗██████╗  ██████╗ ███╗   ███╗    ██╗  ██╗███████╗██████╗ ███████╗                                                   
# ██╔════╝██╔══██╗██╔═══██╗████╗ ████║    ██║  ██║██╔════╝██╔══██╗██╔════╝                                                   
# █████╗  ██████╔╝██║   ██║██╔████╔██║    ███████║█████╗  ██████╔╝█████╗                                                     
# ██╔══╝  ██╔══██╗██║   ██║██║╚██╔╝██║    ██╔══██║██╔══╝  ██╔══██╗██╔══╝                                                     
# ██║     ██║  ██║╚██████╔╝██║ ╚═╝ ██║    ██║  ██║███████╗██║  ██║███████╗                                                   
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝                                                   
                                                                                                                           
# ██╗   ██╗███╗   ██╗██╗     ███████╗███████╗███████╗    ██╗   ██╗ ██████╗ ██╗   ██╗    ██╗  ██╗███╗   ██╗ ██████╗ ██╗    ██╗
# ██║   ██║████╗  ██║██║     ██╔════╝██╔════╝██╔════╝    ╚██╗ ██╔╝██╔═══██╗██║   ██║    ██║ ██╔╝████╗  ██║██╔═══██╗██║    ██║
# ██║   ██║██╔██╗ ██║██║     █████╗  ███████╗███████╗     ╚████╔╝ ██║   ██║██║   ██║    █████╔╝ ██╔██╗ ██║██║   ██║██║ █╗ ██║
# ██║   ██║██║╚██╗██║██║     ██╔══╝  ╚════██║╚════██║      ╚██╔╝  ██║   ██║██║   ██║    ██╔═██╗ ██║╚██╗██║██║   ██║██║███╗██║
# ╚██████╔╝██║ ╚████║███████╗███████╗███████║███████║       ██║   ╚██████╔╝╚██████╔╝    ██║  ██╗██║ ╚████║╚██████╔╝╚███╔███╔╝
#  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝╚══════╝       ╚═╝    ╚═════╝  ╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ 
                                                                                                                           
# ██╗    ██╗██╗  ██╗ █████╗ ████████╗    ██╗   ██╗ ██████╗ ██╗   ██╗    ██████╗  ██████╗ ██╗███╗   ██╗ ██████╗ ██╗           
# ██║    ██║██║  ██║██╔══██╗╚══██╔══╝    ╚██╗ ██╔╝██╔═══██╗██║   ██║    ██╔══██╗██╔═══██╗██║████╗  ██║██╔════╝ ██║           
# ██║ █╗ ██║███████║███████║   ██║        ╚████╔╝ ██║   ██║██║   ██║    ██║  ██║██║   ██║██║██╔██╗ ██║██║  ███╗██║           
# ██║███╗██║██╔══██║██╔══██║   ██║         ╚██╔╝  ██║   ██║██║   ██║    ██║  ██║██║   ██║██║██║╚██╗██║██║   ██║╚═╝           
# ╚███╔███╔╝██║  ██║██║  ██║   ██║          ██║   ╚██████╔╝╚██████╔╝    ██████╔╝╚██████╔╝██║██║ ╚████║╚██████╔╝██╗           
#  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝          ╚═╝    ╚═════╝  ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝   




# get just the tag from the docker image  
SUCCINCT_TAG=$(echo $OP_SUCCINCT_TAG_DOCKER | cut -d: -f2)






echo " ██████╗ ███████╗ ██████╗ ██╗   ██╗██╗██████╗ ███████╗███╗   ███╗███████╗███╗   ██╗████████╗███████╗"
echo " ██╔══██╗██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔════╝████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔════╝"
echo " ██████╔╝█████╗  ██║   ██║██║   ██║██║██████╔╝█████╗  ██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████╗"
echo " ██╔══██╗██╔══╝  ██║▄▄ ██║██║   ██║██║██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║"
echo " ██║  ██║███████╗╚██████╔╝╚██████╔╝██║██║  ██║███████╗██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ███████║"
echo " ╚═╝  ╚═╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝"
requirements() {
  # no frontend

  DEBIAN_FRONTEND=noninteractive sudo apt-get update
  DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
    jq python3 docker.io ca-certificates curl gnupg \
    lsb-release docker-buildx python3-pip tmux pkg-config libssl-dev
  sudo usermod -aG docker "$USER"
  orig_group=$(id -gn)
  # THAT OPENS A NEW SHELL, so execution will be paused here...
  orig_group=$orig_group newgrp docker && newgrp $orig_group

  pip3 install web3
  curl -L https://foundry.paradigm.xyz | bash
  source /home/opstack/.bashrc
  foundryup

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm install v20.19.0

  curl https://dl.google.com/go/go1.24.3.linux-amd64.tar.gz -o /tmp/go1.24.3.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.24.3.linux-amd64.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  # set path in .bashrc
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

  sudo snap install just --classic
}

if ! command -v go &> /dev/null
then
  echo "Go is not installed, installing requirements..."
  requirements
else
  echo "Requirements OK"
fi

rm -fr $WORKDIR/vars.sh
rm -fr $WORKDIR/data
rm -fr $WORKDIR/scripts


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


save_var WORKDIR $WORKDIR
save_var NETWORKNAME $NETWORKNAME
save_var CHAINID $CHAINID
save_var SEPOLIA_PROVIDER $SEPOLIA_PROVIDER
save_var SP1_NETWORK_KEY $SP1_NETWORK_KEY
# This is just required in 1 step for contract deployment, as Tenderly does not work
save_var INFURA_SEPOLIA_PROVIDER $INFURA_SEPOLIA_PROVIDER
save_var SEPOLIA_WS_PROVIDER $SEPOLIA_WS_PROVIDER
save_var SEPOLIA_FUNDED_KEY $SEPOLIA_FUNDED_KEY
save_var SEPOLIA_FUNDED_ADDR $(cast wallet address --private-key $SEPOLIA_FUNDED_KEY)

save_var OP_NODE_TAG $OP_NODE_TAG
save_var OP_GETH_TAG $OP_GETH_TAG
save_var OP_BATCHER_TAG $OP_BATCHER_TAG
save_var OP_PROPOSER_TAG $OP_PROPOSER_TAG
save_var OP_DEPLOYER_TAG_DOCKER $OP_DEPLOYER_TAG_DOCKER

save_var AGGLAYER_TAG $AGGLAYER_TAG
save_var AGGKIT_TAG $AGGKIT_TAG
save_var OP_SUCCINCT_TAG_DOCKER $OP_SUCCINCT_TAG_DOCKER
save_var AGGKITPROVER_TAG $AGGKITPROVER_TAG
save_var SUCCINCT_TAG $SUCCINCT_TAG

save_var SEPOLIA_CHAINID 11155111

save_var SCRIPTDIR ${WORKDIR}/scripts
save_var REPODIR ${WORKDIR}/repos
save_var RUNDIR ${WORKDIR}/run
save_var DATA ${WORKDIR}/data

mkdir -p $REPODIR $RUNDIR $DATA $SCRIPTDIR
cd $WORKDIR


echo "  ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗    ██╗    ██╗ █████╗ ██╗     ██╗     ███████╗████████╗███████╗"
echo " ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ██║    ██║██╔══██╗██║     ██║     ██╔════╝╚══██╔══╝██╔════╝"
echo " ██║     ██████╔╝█████╗  ███████║   ██║   █████╗      ██║ █╗ ██║███████║██║     ██║     █████╗     ██║   ███████╗"
echo " ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝      ██║███╗██║██╔══██║██║     ██║     ██╔══╝     ██║   ╚════██║"
echo " ╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗    ╚███╔███╔╝██║  ██║███████╗███████╗███████╗   ██║   ███████║"
echo "  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝   ╚═╝   ╚══════╝"
> ${SCRIPTDIR}/wallets.py cat <<EOF
import json
from eth_account import Account

Account.enable_unaudited_hdwallet_features()

wallets = [
  'opadmin', 'batcher', 'proposer', 'sequencer', 'challenger', 'zkevmadmin',
  'l2funded', 'feerecipient', 'unsafeblocksigner', 'agglayer', 'aggsender',
  'aggoracle', 'claimtx'
]
result = {}
for wallet_name in wallets:
  wallet, mnemonic = Account.create_with_mnemonic()
  wallet_addr = wallet.address
  wallet_key = wallet.key.hex()
  result[wallet_name] = {'address': wallet_addr, 'key': wallet_key, 'mnemonic': mnemonic}

with open('wallets.json', 'w') as f:
  json.dump(result, f, indent=4)
EOF
python3 ${SCRIPTDIR}/wallets.py
mv wallets.json $DATA/

save_var SEQUENCER $(jq -r .sequencer.address $DATA/wallets.json)
save_var L2FUNDED $(jq -r .l2funded.address $DATA/wallets.json)
save_var L2FUNDED_KEY $(jq -r .l2funded.key $DATA/wallets.json)
save_var ZKEVM_ADMIN $(jq -r .zkevmadmin.address $DATA/wallets.json)
save_var ZKEVM_ADMIN_KEY $(jq -r .zkevmadmin.key $DATA/wallets.json)
save_var ZKEVM_ADMIN_MNEMONIC "$(jq -r .zkevmadmin.mnemonic $DATA/wallets.json)"
save_var FEERECIPIENT $(jq -r .feerecipient.address $DATA/wallets.json)
save_var OPADMIN $(jq -r .opadmin.address $DATA/wallets.json)
save_var OPADMIN_KEY $(jq -r .opadmin.key $DATA/wallets.json)
save_var BATCHER $(jq -r .batcher.address $DATA/wallets.json)
save_var BATCHER_KEY $(jq -r .batcher.key $DATA/wallets.json)
save_var PROPOSER $(jq -r .proposer.address $DATA/wallets.json)
save_var PROPOSER_KEY $(jq -r .proposer.key $DATA/wallets.json)
save_var CHALLENGER $(jq -r .challenger.address $DATA/wallets.json)
save_var UNSAFEBLOCKSIGNER $(jq -r .unsafeblocksigner.address $DATA/wallets.json)
save_var AGGLAYER $(jq -r .agglayer.address $DATA/wallets.json)
save_var AGGLAYER_KEY $(jq -r .agglayer.key $DATA/wallets.json)
save_var AGGSENDER $(jq -r .aggsender.address $DATA/wallets.json)
save_var AGGSENDER_KEY $(jq -r .aggsender.key $DATA/wallets.json)
save_var AGGORACLE $(jq -r .aggoracle.address $DATA/wallets.json)
save_var AGGORACLE_KEY $(jq -r .aggoracle.key $DATA/wallets.json)
save_var CLAIMTX $(jq -r .claimtx.address $DATA/wallets.json)
save_var CLAIMTX_KEY $(jq -r .claimtx.key $DATA/wallets.json)


echo " ███████╗███████╗████████╗██╗   ██╗██████╗     ██████╗ ███████╗██████╗  ██████╗ ███████╗"
echo " ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝"
echo " ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██████╔╝█████╗  ██████╔╝██║   ██║███████╗"
echo " ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║╚════██║"
echo " ███████║███████╗   ██║   ╚██████╔╝██║         ██║  ██║███████╗██║     ╚██████╔╝███████║"
echo " ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚══════╝"
                                                                                       
echo "  █████╗ ███╗   ██╗██████╗     ██████╗ ██╗███╗   ██╗ █████╗ ██████╗ ██╗███████╗███████╗ "
echo " ██╔══██╗████╗  ██║██╔══██╗    ██╔══██╗██║████╗  ██║██╔══██╗██╔══██╗██║██╔════╝██╔════╝ "
echo " ███████║██╔██╗ ██║██║  ██║    ██████╔╝██║██╔██╗ ██║███████║██████╔╝██║█████╗  ███████╗ "
echo " ██╔══██║██║╚██╗██║██║  ██║    ██╔══██╗██║██║╚██╗██║██╔══██║██╔══██╗██║██╔══╝  ╚════██║ "
echo " ██║  ██║██║ ╚████║██████╔╝    ██████╔╝██║██║ ╚████║██║  ██║██║  ██║██║███████╗███████║ "
echo " ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝ "

repos() {
  export PATH=$PATH:/usr/local/go/bin

  cd $REPODIR
  save_var ZKEVM_CONTRACTS ${REPODIR}/agglayer-contracts
  save_var OPMONOREPODIR ${REPODIR}/optimism
  save_var OPGETHDIR ${REPODIR}/op-geth
  save_var AGGLAYERREPODIR ${REPODIR}/agglayer
  save_var AGGKITREPODIR ${REPODIR}/aggkit
  save_var BRIDGEDIR ${REPODIR}/bridge
  save_var POLYCLI $REPODIR/polycli
  save_var AGGKITPROVERREPODIR ${REPODIR}/aggkit-prover
  save_var OPSUCCINCTDIR ${REPODIR}/op-succinct

  if [ ! -d $ZKEVM_CONTRACTS ]; then
    git clone https://github.com/agglayer/agglayer-contracts/ $ZKEVM_CONTRACTS
  fi

  # clone the monorepo for op-node, op-batcher, op-proposer and op-deployer if it does not exist
  if [ ! -d $OPMONOREPODIR ]; then
    git clone https://github.com/ethereum-optimism/optimism.git $OPMONOREPODIR
  fi

  # compile op-node if the binary does not exist
  if [ ! -f $RUNDIR/op-node ]; then
    cd $OPMONOREPODIR/op-node
    git fetch
    git checkout $OP_NODE_TAG
    make
    cp bin/op-node $RUNDIR/op-node
  fi

  # compile op-batcher if the binary does not exist
  if [ ! -f $RUNDIR/op-batcher ]; then
    cd $OPMONOREPODIR/op-batcher
    gt fetch
    git checkout $OP_BATCHER_TAG
    make
    cp bin/op-batcher $RUNDIR/op-batcher
  fi

  # compile op-proposer
  if [ ! -d $OPMONOREPODIR/op-proposer ]; then
    cd $OPMONOREPODIR/op-proposer
    git fetch
    git checkout $OP_PROPOSER_TAG
    make
    cp bin/op-proposer $RUNDIR/op-proposer
  fi

  if [ ! -d $OPGETHDIR ]; then
    git clone https://github.com/ethereum-optimism/op-geth.git $OPGETHDIR
  fi

  # compile op-geth
  if [ ! -f $RUNDIR/op-geth ]; then
    cd $OPGETHDIR
    git fetch
    git checkout $OP_GETH_TAG
    make
    cp build/bin/geth $RUNDIR/op-geth
  fi

  # retrieve op-deployer binary from docker - we NEED PATCHED VERSION OVER another tag
  if [ ! -f $RUNDIR/op-deployer ]; then
    docker pull $OP_DEPLOYER_TAG_DOCKER
    docker run --detach --rm --name opdeployer_tmp $OP_DEPLOYER_TAG_DOCKER sleep 30
    docker cp opdeployer_tmp:/usr/local/bin/op-deployer $RUNDIR/
  fi

  if [ ! -d $AGGLAYERREPODIR ]; then
    git clone https://github.com/agglayer/agglayer.git $AGGLAYERREPODIR
  fi

  # agglayer
  if [ ! -f $RUNDIR/agglayer.${AGGLAYER_TAG} ]; then
    cd $AGGLAYERREPODIR
    git fetch
    git checkout $AGGLAYER_TAG
    # sed -i 's/bullseye/bookworm/g' Dockerfile
    docker buildx build --build-arg BUILDPLATFORM=linux/amd64 --no-cache -t agglayer:local .
    # get the binary from the docker we just built
    docker run --detach --rm --name agglayer_tmp agglayer:local sleep 30
    docker cp agglayer_tmp:/usr/local/bin/agglayer $RUNDIR/agglayer.${AGGLAYER_TAG}
  fi

  if [ ! -d $AGGKITREPODIR ]; then
    git clone https://github.com/agglayer/aggkit.git $AGGKITREPODIR
  fi

  # build if binary not there
  if [ ! -f $RUNDIR/aggkit.${AGGKIT_TAG} ]; then
    cd $AGGKITREPODIR
    git fetch
    git checkout $AGGKIT_TAG
    make build
    cp ./target/aggkit $RUNDIR/aggkit.${AGGKIT_TAG}
  fi

  if [ ! -d $BRIDGEDIR ]; then
    git clone https://github.com/0xPolygonHermez/zkevm-bridge-service.git $BRIDGEDIR
  fi

  # build bridge if not there
  if [ ! -f $RUNDIR/bridge ]; then
    cd $BRIDGEDIR
    git fetch
    git checkout $BRIDGE_TAG
    make build
    cp dist/zkevm-bridge $RUNDIR/bridge
  fi

  if [ ! -d $POLYCLI ]; then
    git clone https://github.com/0xPolygon/polygon-cli.git $POLYCLI
  fi

  # build polycli if not there
  if [ ! -f $RUNDIR/polycli ]; then
    cd $POLYCLI
    git fetch
    make build
    cp out/polycli $RUNDIR/
  fi

  # get op-succinct binary if not there
  if [ ! -f $RUNDIR/op-succinct.${SUCCINCT_TAG} ]; then
    docker pull $OP_SUCCINCT_TAG_DOCKER
    # get just version of the tag, the work after :
    save_var SUCCINCT_TAG $SUCCINCT_TAG
    docker run --detach --rm --name opsuccinct_tmp $OP_SUCCINCT_TAG_DOCKER sleep 30
    docker cp opsuccinct_tmp:/usr/local/bin/validity-proposer $RUNDIR/op-succinct.${SUCCINCT_TAG}
  fi

  if [ ! -d $AGGKITPROVERREPODIR ]; then
    git clone https://github.com/agglayer/provers $AGGKITPROVERREPODIR
  fi

  # get aggkit prover binary if not there
  if [ ! -f $RUNDIR/aggkit-prover.${AGGKITPROVER_TAG} ]; then
    cd $AGGKITPROVERREPODIR
    git fetch
    git checkout $AGGKITPROVER_TAG
    sed -i 's/bullseye/bookworm/g' Dockerfile
    docker buildx build --build-arg BUILDPLATFORM=linux/amd64 --no-cache -t aggkit-prover:local .
    docker run --detach --rm --name aggkitprover_tmp aggkit-prover:local sleep 30
    docker cp aggkitprover_tmp:/usr/local/bin/aggkit-prover $RUNDIR/aggkit-prover.${AGGKITPROVER_TAG}
  fi

  if [ ! -d $OPSUCCINCTDIR ]; then
    git clone https://github.com/agglayer/op-succinct.git $OPSUCCINCTDIR
  fi

  # GET fetch-rollup-config if not there
  if [ ! -f $RUNDIR/fetch-rollup-config.${SUCCINCT_TAG} ]; then
    cd $OPSUCCINCTDIR
    git fetch
    git checkout $SUCCINCT_TAG
    cat > Dockerfile <<EOF
FROM rust:slim-bookworm AS builder

ARG OP_SUCCINCT_BRANCH
WORKDIR /opt

RUN apt-get update \
    && apt-get install --yes --no-install-recommends curl \
      build-essential ca-certificates git pkg-config \
      libssl-dev clang libclang-dev jq 

RUN curl -sL https://just.systems/install.sh | bash -s -- --to /usr/local/bin

WORKDIR /opt
RUN git clone https://github.com/succinctlabs/sp1-contracts.git

WORKDIR /opt/op-succinct
RUN git clone https://github.com/agglayer/op-succinct.git . \
    && git checkout \${OP_SUCCINCT_BRANCH} \
    && git submodule update --init --recursive

RUN cargo build --release \
    && cp target/release/fetch-rollup-config /usr/local/bin/
EOF
    docker build --build-arg OP_SUCCINCT_BRANCH=$SUCCINCT_TAG --file Dockerfile -t op-succinct:$SUCCINCT_TAG .
    docker run --detach --rm --name opsuccinct_tmp op-succinct:$SUCCINCT_TAG sleep 30
    docker cp opsuccinct_tmp:/usr/local/bin/fetch-rollup-config $RUNDIR/fetch-rollup-config.$SUCCINCT_TAG
  fi

}

# download repos and build binaries for everything
repos


echo "███╗   ██╗ ██████╗ ██████╗ ███████╗    ███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗██╗     ███████╗███████╗"
echo "████╗  ██║██╔═══██╗██╔══██╗██╔════╝    ████╗ ████║██╔═══██╗██╔══██╗██║   ██║██║     ██╔════╝██╔════╝"
echo "██╔██╗ ██║██║   ██║██║  ██║█████╗      ██╔████╔██║██║   ██║██║  ██║██║   ██║██║     █████╗  ███████╗"
echo "██║╚██╗██║██║   ██║██║  ██║██╔══╝      ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██║     ██╔══╝  ╚════██║"
echo "██║ ╚████║╚██████╔╝██████╔╝███████╗    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝███████╗███████╗███████║"
echo "╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝"
 
cd $ZKEVM_CONTRACTS
git stash && git checkout $ZKEVM_CONTRACTS_TAG
rm -fr .openzeppelin/ deployment/v2/deploy_ongoing.json deployment/v2/deploy_parameters.json deployment/v2/create_rollup_parameters.json package-lock.json node_modules
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use v20.19.0
npm i


echo " ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗     ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  █████╗  ██████╗████████╗███████╗"
echo " ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝"
echo " ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝     ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║        ██║   ███████╗"
echo " ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝      ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║        ██║   ╚════██║"
echo " ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║       ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║╚██████╗   ██║   ███████║"
echo " ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚══════╝"

save_var AGGLAYER_VKEY $($RUNDIR/agglayer.${AGGLAYER_TAG} vkey)
save_var AGGLAYER_VKEYSELECTOR $($RUNDIR/agglayer.${AGGLAYER_TAG} vkey-selector)

# deploy_parameters.json
jq --arg ZKEVMADMIN "$ZKEVM_ADMIN" \
  --arg ZKEVMDEPLOYER_KEY "$ZKEVM_ADMIN_KEY" \
  --arg PPVKEY "$AGGLAYER_VKEY" \
  --arg PPVKEYSELECTOR "$AGGLAYER_VKEYSELECTOR" \
   '
   .timelockAdminAddress = $ZKEVMADMIN |
   .admin = $ZKEVMADMIN |
   .initialZkEVMDeployerOwner = $ZKEVMADMIN |
   .emergencyCouncilAddress = $ZKEVMADMIN |
   .trustedAggregator = $ZKEVMADMIN |
   .deployerPvtKey = $ZKEVMDEPLOYER_KEY |
   .polTokenAddress = "" |
   .realVerifier = true |
   .ppVKey = $PPVKEY |
   .ppVKeySelector = $PPVKEYSELECTOR |
   .salt = "0x0000000000000000000000000000000000000000000000000000000000000003"
   ' deployment/v2/deploy_parameters.json.example > deployment/v2/deploy_parameters.json
cp deployment/v2/deploy_parameters.json $DATA/

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
   .gasTokenAddress = "0x0000000000000000000000000000000000000000" |
   .sovereignParams.bridgeManager = $ZKEVMADMIN |
   .sovereignParams.globalExitRootUpdater = $AGGORACLE |
   .sovereignParams.globalExitRootRemover = $AGGORACLE |
   .sovereignParams.emergencyBridgePauser = $ZKEVMADMIN |
   del(.aggchainParams)
   ' deployment/v2/create_rollup_parameters.json.example > deployment/v2/create_rollup_parameters.json
cp deployment/v2/create_rollup_parameters.json $DATA/

# Fund the deployer
cast send --rpc-url $SEPOLIA_PROVIDER --value 2ether --private-key $SEPOLIA_FUNDED_KEY $ZKEVM_ADMIN

# zkevm-contracts deployment
SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run deployment/testnet/prepareTestnet.ts --network sepolia 2>&1 | tee $DATA/01_prepare_testnet.out
MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx ts-node deployment/v2/1_createGenesis.ts --network sepolia 2>&1 | tee $DATA/02_create_genesis.out
MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run deployment/v2/2_deployPolygonZKEVMDeployer.ts --network sepolia 2>&1 | tee $DATA/03_zkevm_deployer.out
# This specific step fails silently with Tenderly, so using that Infura endpoint from free personal account
MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$INFURA_SEPOLIA_PROVIDER npx hardhat run deployment/v2/3_deployContracts.ts --network sepolia 2>&1 | tee $DATA/04_deploy_contracts.out
MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER npx hardhat run deployment/v2/4_createRollup.ts --network sepolia 2>&1 | tee $DATA/05_create_rollup.out

save_var CREATE_ROLLUP_OUTPUT_FILE $(basename $(find deployment/v2/ -name 'create_rollup_output*' | head -n 1))

cp deployment/v2/genesis.json $DATA/
cp deployment/v2/${CREATE_ROLLUP_OUTPUT_FILE} $DATA/
cp deployment/v2/deploy_output.json $DATA/

# trustedsequencer set on create rollup needs to match with the address configured for aggsender
# if that's not the case, that can be fixed later that way:
#  cast send \
#      --rpc-url $SEPOLIA_PROVIDER \
#      --private-key $ZKEVM_ADMIN_KEY \
#      $ROLLUP_ADDR \
#      'setTrustedSequencer(address)' \
#      $AGGSENDER


# create sovereign genesis
save_var ROLLUPMANAGER $(jq -r .polygonRollupManagerAddress $DATA/deploy_output.json)
save_var PPVKEY_VERIFIER $(jq -r .pessimisticVKeyRouteALGateway.verifier $DATA/deploy_output.json)

# create-genesis-sovereign-params.json
jq --arg ZKEVMADMIN "$ZKEVM_ADMIN" \
   --arg CHAINID "$CHAINID" \
   --arg ZKEVMDEPLOYER_KEY "$ZKEVM_ADMIN_KEY" \
   --arg L2FUNDED "$L2FUNDED" \
   --arg ROLLUPMAN "$ROLLUPMANAGER" \
   '
   .rollupManagerAddress = $ROLLUPMAN |
   .rollupID = 1 |
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
cp $DATA/genesis.json tools/createSovereignGenesis/genesis-base.json

MNEMONIC="$ZKEVM_ADMIN_MNEMONIC" SEPOLIA_PROVIDER=$SEPOLIA_PROVIDER  npx hardhat run ./tools/createSovereignGenesis/create-sovereign-genesis.ts --network sepolia 2>&1 | tee $DATA/06_create-sovereign-genesis.out

cp tools/createSovereignGenesis/genesis-rollup* $DATA/
cp tools/createSovereignGenesis/output-rollup* $DATA/
cp tools/createSovereignGenesis/create-genesis-sovereign-params.json $DATA/

save_var SOVEREIGN_GENESIS_FILE $(basename $(find $DATA -name 'genesis-rollupID*' | head -n 1))
save_var OUTPUT_ROLLUPID_FILE $(basename $(find $DATA -name 'output-rollupID*' | head -n 1))

cd $WORKDIR
cp $DATA/$SOVEREIGN_GENESIS_FILE $DATA/zkevm_allocs.json


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
  --http.api=admin,engine,net,eth,web3,debug,miner,txpool \
  --ws \
  --ws.addr=0.0.0.0 \
  --ws.port=8546 \
  --ws.origins="*" \
  --ws.api=debug,eth,txpool,net,engine \
  --syncmode=full \
  --gcmode=archive \
  --nodiscover \
  --maxpeers=0 \
  --networkid=$CHAINID \
  --authrpc.vhosts="*" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port=8551 \
  --authrpc.jwtsecret=${RUNDIR}/jwt.txt \
  --rpc.allow-unprotected-txs \
  --rollup.disabletxpoolgossip=true \
  --miner.gaslimit=90000000"

tmux new-session -d -s "opgeth"
tmux send-keys -t "opgeth" "$CMD" C-m

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

# run op-node
CMD="${RUNDIR}/op-node \
  --l2=http://localhost:8551 \
  --l2.jwt-secret=${RUNDIR}/jwt.txt \
  --sequencer.enabled \
  --sequencer.l1-confs=5 \
  --verifier.l1-confs=4 \
  --rollup.config=$ROLLUP_JSON \
  --rpc.addr=0.0.0.0 \
  --p2p.disable \
  --rpc.enable-admin \
  --l1=$SEPOLIA_PROVIDER \
  --l1.beacon=$SEPOLIA_PROVIDER \
  --l1.rpckind=standard \
  --safedb.path=${RUNDIR}/opnodedb"

tmux new-session -d -s "opnode"
tmux send-keys -t "opnode" "$CMD" C-m

sleep 20

# fund the batcher
cast send --rpc-url $SEPOLIA_PROVIDER --value 0.5ether --private-key $SEPOLIA_FUNDED_KEY $BATCHER
# run op-batcher
CMD="${RUNDIR}/op-batcher \
  --l2-eth-rpc=http://localhost:8545 \
  --rollup-rpc=http://localhost:9545 \
  --poll-interval=1s \
  --sub-safety-margin=6 \
  --num-confirmations=1 \
  --safe-abort-nonce-too-low-count=3 \
  --resubmission-timeout=30s \
  --rpc.addr=0.0.0.0 \
  --rpc.port=8548 \
  --rpc.enable-admin \
  --max-channel-duration=25 \
  --l1-eth-rpc=$SEPOLIA_PROVIDER \
  --private-key=$BATCHER_KEY \
  --data-availability-type=blobs \
  --throttle-block-size=400000"

tmux new-session -d -s "opbatcher"
tmux send-keys -t "opbatcher" "$CMD" C-m


echo " ██████╗ ██╗   ██╗███╗   ██╗     █████╗  ██████╗  ██████╗ ██╗      █████╗ ██╗   ██╗███████╗██████╗ "
echo " ██╔══██╗██║   ██║████╗  ██║    ██╔══██╗██╔════╝ ██╔════╝ ██║     ██╔══██╗╚██╗ ██╔╝██╔════╝██╔══██╗"
echo " ██████╔╝██║   ██║██╔██╗ ██║    ███████║██║  ███╗██║  ███╗██║     ███████║ ╚████╔╝ █████╗  ██████╔╝"
echo " ██╔══██╗██║   ██║██║╚██╗██║    ██╔══██║██║   ██║██║   ██║██║     ██╔══██║  ╚██╔╝  ██╔══╝  ██╔══██╗"
echo " ██║  ██║╚██████╔╝██║ ╚████║    ██║  ██║╚██████╔╝╚██████╔╝███████╗██║  ██║   ██║   ███████╗██║  ██║"
echo " ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝"
# run agglayer prover and agglayer

mkdir -p ${DATA}/agglayer

> ${DATA}/agglayer/agglayer-prover-config.toml cat <<EOF
grpc-endpoint = "0.0.0.0:4445"
max-concurrency-limit = 100
max-request-duration = 300
max-buffered-queries = 100

[log]
environment = "production" # "production" or "development"
level = "info"
outputs = ["stderr"]
format = "json"

[primary-prover.network-prover]
proving-timeout = 900

[grpc]
max-decoding-message-size = 104857600
EOF

cd $RUNDIR

# AGGLAYER PROVER
CMD="NETWORK_PRIVATE_KEY=$SP1_NETWORK_KEY $RUNDIR/agglayer.${AGGLAYER_TAG} prover --cfg $DATA/agglayer/agglayer-prover-config.toml 2>&1 | tee $RUNDIR/agglayer-prover.log"

tmux new-session -d -s "agglayerprover"
tmux send-keys -t "agglayerprover" "$CMD" C-m

# prepare agglayer vars
save_var GERMANAGER $(jq -r .polygonZkEVMGlobalExitRootAddress $DATA/deploy_output.json)
save_var RM_BLOCKNUMBER $(jq -r .deploymentRollupManagerBlockNumber $DATA/deploy_output.json)
# Agglayer keystore
save_var KEYSTORE_PASSWORD SuperSecret
cast wallet import --keystore-dir "${DATA}/agglayer" --private-key "$AGGLAYER_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "agglayer.keystore"

> ${DATA}/agglayer/agglayer-config.toml cat <<EOF
prover-entrypoint = "http://localhost:4445"
debug-mode = true

# Only supported by fork 12+
mock-verifier = false

[full-node-rpcs]
# OP Stack RPC
1 = "http://localhost:8545"

[proof-signers]
# AggSneder (who signs the certificate)
1 = "${AGGSENDER}"

[rpc]
grpc-port = 4443
readrpc-port = 4444
admin-port = 4446
host = "0.0.0.0"
request-timeout = 180
max-request-body-size = 104857600

[prover.grpc]
max-decoding-message-size = 104857600

[outbound.rpc.settle]
max-retries = 3
retry-interval = 7
confirmations = 1
settlement-timeout = 1200

[log]
level = "info"
outputs = ["stderr"]
format = "json"

[auth.local]
private-keys = [
    { path = "${DATA}/agglayer/agglayer.keystore", password = "$KEYSTORE_PASSWORD" },
]

[telemetry]
prometheus-addr = "0.0.0.0:3009"

[l1]
chain-id = $SEPOLIA_CHAINID
node-url = "$SEPOLIA_PROVIDER"
ws-node-url = "$SEPOLIA_WS_PROVIDER"
rollup-manager-contract = "$ROLLUPMANAGER"
polygon-zkevm-global-exit-root-v2-contract = "$GERMANAGER"
rpc-timeout = 45

[l2]
rpc-timeout = 45

[rate-limiting]
send-tx = "unlimited"

[rate-limiting.network]

[epoch.block-clock]
epoch-duration = 15
genesis-block = $RM_BLOCKNUMBER

[shutdown]
runtime-timeout = 5

[certificate-orchestrator]
input-backpressure-buffer-size = 1000

[certificate-orchestrator.prover.sp1-local]

[storage]
db-path = "$DATA/agglayer/storage"

# [storage.backup]
# path = "$DATA/agglayer/backups"
# state-max-backup-count = 100
# pending-max-backup-count = 100
EOF

# Grant aggregator role to agglayer so it can verify
cast send \
  --private-key $ZKEVM_ADMIN_KEY \
  --rpc-url $SEPOLIA_PROVIDER \
  $ROLLUPMANAGER \
  'grantRole(bytes32,address)' \
  $(cast keccak "TRUSTED_AGGREGATOR_ROLE") $AGGLAYER

# fund agglayer
cast send --rpc-url $SEPOLIA_PROVIDER --value 0.5ether --private-key $SEPOLIA_FUNDED_KEY $AGGLAYER

# RUN AGGLAYER!
CMD="$RUNDIR/agglayer.${AGGLAYER_TAG} run --cfg $DATA/agglayer/agglayer-config.toml 2>&1 | tee $RUNDIR/agglayer.log"

tmux new-session -d -s "agglayer"
tmux send-keys -t "agglayer" "$CMD" C-m


echo " ██████╗ ██╗   ██╗███╗   ██╗     █████╗  ██████╗  ██████╗ ██╗  ██╗██╗████████╗"
echo " ██╔══██╗██║   ██║████╗  ██║    ██╔══██╗██╔════╝ ██╔════╝ ██║ ██╔╝██║╚══██╔══╝"
echo " ██████╔╝██║   ██║██╔██╗ ██║    ███████║██║  ███╗██║  ███╗█████╔╝ ██║   ██║   "
echo " ██╔══██╗██║   ██║██║╚██╗██║    ██╔══██║██║   ██║██║   ██║██╔═██╗ ██║   ██║   "
echo " ██║  ██║╚██████╔╝██║ ╚████║    ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗██║   ██║   "
echo " ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   "
cd $RUNDIR
mkdir -p $DATA/aggkit/tmp

# save_var L2_BRIDGE_ADDR $(cat $DATA/$SOVEREIGN_GENESIS_FILE | jq -r '.genesis[] | select(.contractName == "BridgeL2SovereignChain proxy") | .address')
save_var L2_BRIDGE_ADDR $(cat $DATA/$OUTPUT_ROLLUPID_FILE | jq -r '.genesisSCNames."BridgeL2SovereignChain proxy"')
# save_var L2_GERMANAGER_ADDR $(cat $DATA/$SOVEREIGN_GENESIS_FILE | jq -r '.genesis[] | select(.contractName == "GlobalExitRootManagerL2SovereignChain proxy") | .address')
save_var L2_GERMANAGER_ADDR $(cat $DATA/$OUTPUT_ROLLUPID_FILE | jq -r '.genesisSCNames."GlobalExitRootManagerL2SovereignChain proxy"')
save_var POLTOKENADDR $(jq -r .polTokenAddress $DATA/deploy_output.json)
save_var BRIDGE_ADDR $(jq -r .polygonZkEVMBridgeAddress $DATA/deploy_output.json)
# save_var ROLLUP_ADDR $(jq -r .rollupAddress $DATA/create_rollup_output.json)
save_var ROLLUP_ADDR $(cat $DATA/$OUTPUT_ROLLUPID_FILE | jq -r '.RollupManagerInfo.rollupData.rollupAddress')

cast wallet import --keystore-dir "${DATA}/aggkit" --private-key "$AGGSENDER_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "aggsender.keystore"
cast wallet import --keystore-dir "${DATA}/aggkit" --private-key "$AGGORACLE_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "aggoracle.keystore"

# fund aggoracle to accept GER transfer
cast send --value 5ether --private-key $L2FUNDED_KEY $AGGORACLE

# Set GER updater/remover to AggOracle address
cast send \
  --private-key $ZKEVM_ADMIN_KEY \
  $L2_GERMANAGER_ADDR \
  'transferGlobalExitRootUpdater(address)' \
  $AGGORACLE

cast send \
  --private-key $AGGORACLE_KEY \
  $L2_GERMANAGER_ADDR \
  'acceptGlobalExitRootUpdater()'

cast send \
  --private-key $ZKEVM_ADMIN_KEY \
  $L2_GERMANAGER_ADDR \
  'transferGlobalExitRootRemover(address)' \
  $AGGORACLE

cast send \
  --private-key $AGGORACLE_KEY \
  $L2_GERMANAGER_ADDR \
  'acceptGlobalExitRootRemover()'


# checking the current set address:
# cast call $L2_GERMANAGER_ADDR 'globalExitRootUpdater()'

> ${DATA}/aggkit/aggkit-config.toml cat <<EOF
PathRWData = "$DATA/aggkit/tmp/"
L1URL="$SEPOLIA_PROVIDER"
L2URL="http://localhost:8545"
# GRPC port for Aggkit v0.3
# readport for Aggkit v0.2
AggLayerURL="http://localhost:4443"

ForkId = 12
ContractVersions = "banana"
IsValidiumMode = false
NetworkID = 1

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
Port = 5576

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
EOF

# aggoracle needs some funds
cast send --rpc-url $SEPOLIA_PROVIDER --value 0.5ether --private-key $SEPOLIA_FUNDED_KEY $AGGORACLE

CMD="$RUNDIR/aggkit.${AGGKIT_TAG} run --cfg=$DATA/aggkit/aggkit-config.toml --components=aggsender,aggoracle 2>&1 | tee $RUNDIR/aggkit.log"

tmux new-session -d -s "aggkit"
tmux send-keys -t "aggkit" "$CMD" C-m


echo " ██████╗ ██╗   ██╗███╗   ██╗    ██████╗ ██████╗ ██╗██████╗  ██████╗ ███████╗"
echo " ██╔══██╗██║   ██║████╗  ██║    ██╔══██╗██╔══██╗██║██╔══██╗██╔════╝ ██╔════╝"
echo " ██████╔╝██║   ██║██╔██╗ ██║    ██████╔╝██████╔╝██║██║  ██║██║  ███╗█████╗  "
echo " ██╔══██╗██║   ██║██║╚██╗██║    ██╔══██╗██╔══██╗██║██║  ██║██║   ██║██╔══╝  "
echo " ██║  ██║╚██████╔╝██║ ╚████║    ██████╔╝██║  ██║██║██████╔╝╚██████╔╝███████╗"
echo " ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝  ╚═════╝ ╚══════╝"

mkdir $DATA/bridge
save_var BRIDGE_USER sovereign_bridge_user
save_var BRIDGE_PASS TopSecret
save_var BRIDGE_DB sovereign_bridge_db


# postgres required by bridge
docker stop postgres
docker rm postgres
docker run --name postgres \
  -e POSTGRES_USER=$BRIDGE_USER \
  -e POSTGRES_PASSWORD=$BRIDGE_PASS \
  -e POSTGRES_DB=$BRIDGE_DB \
  -p 5432:5432 \
  -d postgres:15

# keystore
cast wallet import --keystore-dir "${DATA}/bridge" --private-key "$CLAIMTX_KEY" --unsafe-password "$KEYSTORE_PASSWORD" "claimtx.keystore"

# send l2 funds to claimtx
cast send --value 10ether --private-key $L2FUNDED_KEY $CLAIMTX

save_var DEPLOYBLOCKNUMBER $(jq -r .deploymentRollupManagerBlockNumber $DATA/deploy_output.json)

> ${DATA}/bridge/bridge-config.toml cat <<EOF
[Log]
Level = "info"
Environment = "development"
Outputs = ["stderr"]

[SyncDB]
Database = "postgres"
  [SyncDB.PgStorage]
  User = "$BRIDGE_USER"
  Name = "$BRIDGE_DB"
  Password = "$BRIDGE_PASS"
  Host = "localhost"
  Port = "5432"
  MaxConns = 20

[Etherman]
l1URL = "$SEPOLIA_PROVIDER"
L2URLs = ["http://localhost:8545"]

[Synchronizer]
SyncInterval = "5s"
SyncChunkSize = 100

[BridgeController]
Store = "postgres"
Height = 32

[BridgeServer]
GRPCPort = "9090"
HTTPPort = "8080"
DefaultPageLimit = 25
MaxPageLimit = 1000
BridgeVersion = "v1"
# Read only
[BridgeServer.DB]
Database = "postgres"
  [BridgeServer.DB.PgStorage]
  User = "$BRIDGE_USER"
  Name = "$BRIDGE_DB"
  Password = "$BRIDGE_PASS"
  Host = "localhost"
  Port = "5432"
  MaxConns = 20

[NetworkConfig]
GenBlockNumber = "$DEPLOYBLOCKNUMBER"
PolygonBridgeAddress = "$BRIDGE_ADDR"
PolygonZkEVMGlobalExitRootAddress = "$GERMANAGER"
PolygonRollupManagerAddress = "$ROLLUPMANAGER"
PolygonZkEVMAddress = "$ROLLUP_ADDR"
L2PolygonBridgeAddresses = ["$L2_BRIDGE_ADDR"]
RequireSovereignChainSmcs = [true]
L2PolygonZkEVMGlobalExitRootAddresses = ["$L2_GERMANAGER_ADDR"]

[ClaimTxManager]
FrequencyToMonitorTxs = "5s"
PrivateKey = {Path = "$DATA/bridge/claimtx.keystore", Password = "$KEYSTORE_PASSWORD"}
Enabled = true
RetryInterval = "1s"
RetryNumber = 10

[Metrics]
Enabled = true
Host = "0.0.0.0"
Port = "8097"
EOF

cd $RUNDIR
CMD="./bridge run --cfg $DATA/bridge/bridge-config.toml"
tmux new-session -d -s "bridge"
tmux send-keys -t "bridge" "$CMD" C-m



echo " ██████╗  ██████╗ ███╗   ██╗███████╗██╗                                                                                       "
echo " ██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║                                                                                       "
echo " ██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║                                                                                       "
echo " ██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝                                                                                       "
echo " ██████╔╝╚██████╔╝██║ ╚████║███████╗██╗                                                                                       "
echo " ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝                                                                                       "


echo " ████████╗███████╗███████╗████████╗██╗███╗   ██╗ ██████╗                                                                      "
echo " ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝                                                                      "
echo "    ██║   █████╗  ███████╗   ██║   ██║██╔██╗ ██║██║  ███╗                                                                     "
echo "    ██║   ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██║   ██║                                                                     "
echo "    ██║   ███████╗███████║   ██║   ██║██║ ╚████║╚██████╔╝                                                                     "
echo "    ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝                                                                                             "
echo " ██████╗ ███████╗██████╗  ██████╗ ███████╗██╗████████╗     █████╗ ███╗   ██╗██████╗      ██████╗██╗      █████╗ ██╗███╗   ███╗"
echo " ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝██║╚══██╔══╝    ██╔══██╗████╗  ██║██╔══██╗    ██╔════╝██║     ██╔══██╗██║████╗ ████║"
echo " ██║  ██║█████╗  ██████╔╝██║   ██║███████╗██║   ██║       ███████║██╔██╗ ██║██║  ██║    ██║     ██║     ███████║██║██╔████╔██║"
echo " ██║  ██║██╔══╝  ██╔═══╝ ██║   ██║╚════██║██║   ██║       ██╔══██║██║╚██╗██║██║  ██║    ██║     ██║     ██╔══██║██║██║╚██╔╝██║"
echo " ██████╔╝███████╗██║     ╚██████╔╝███████║██║   ██║       ██║  ██║██║ ╚████║██████╔╝    ╚██████╗███████╗██║  ██║██║██║ ╚═╝ ██║"
echo " ╚═════╝ ╚══════╝╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝      ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝"

l1_deposit_amount="0.01ether"
l1_wei_deposit_amount=$(echo "$l1_deposit_amount" | sed 's/ether//g' | cast to-wei)
l2_wei_deposit_amount=1
 
l1_balance_before=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_before=$(cast balance --rpc-url http://localhost:8545 $SEPOLIA_FUNDED_ADDR)

# Deposit on L1 to avoid negative balance
$RUNDIR/polycli ulxly bridge asset \
    --value $l1_wei_deposit_amount \
    --gas-limit 1250000 \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --destination-network 1 \
    --rpc-url $SEPOLIA_PROVIDER \
    --private-key $SEPOLIA_FUNDED_KEY \
    --chain-id $SEPOLIA_CHAINID

# Allow some time for bridge processing
sleep 300

l1_balance_after=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_after=$(cast balance --rpc-url http://localhost:8545 $SEPOLIA_FUNDED_ADDR)
echo "L1 balance before: $l1_balance_before"
echo "L1 balance after l1 deposit: $l1_balance_after"
echo "L2 balance before: $l2_balance_before"
echo "L2 balance after l1 deposit: $l2_balance_after"

# deposit on L2
$RUNDIR/polycli ulxly bridge asset \
    --value 1 \
    --gas-limit 1250000 \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --destination-network 0 \
    --rpc-url http://localhost:8545 \
    --private-key $SEPOLIA_FUNDED_KEY \
    --chain-id $CHAINID

sleep 300

l1_balance_after2=$(cast balance --rpc-url $SEPOLIA_PROVIDER $SEPOLIA_FUNDED_ADDR)
l2_balance_after2=$(cast balance --rpc-url http://localhost:8545 $SEPOLIA_FUNDED_ADDR)
echo "L1 balance after l2 deposit: $l1_balance_after2"
echo "L2 balance after l2 deposit: $l2_balance_after2"

# claim everything
$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $L2_BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --rpc-url $SEPOLIA_PROVIDER \
    --private-key $SEPOLIA_FUNDED_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080'

$RUNDIR/polycli ulxly claim-everything \
    --bridge-address $BRIDGE_ADDR \
    --destination-address $SEPOLIA_FUNDED_ADDR \
    --rpc-url http://localhost:8545  \
    --private-key $SEPOLIA_FUNDED_KEY \
    --bridge-service-map '0=http://localhost:8080,1=http://localhost:8080'
