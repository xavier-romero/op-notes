# Addresses

## Sequencer

Address used to sign txs sent through P2P for geth clients

- User provided
- Private Key used on op-node to sign P2P transactions
- No funding required
- Optionally set for op-node

## Batcher
Address used to send transaction on L1 for DA

- User provided
- Private Key used to send transaction batches to L1 (Batch Inbox address?)
- Funds required on L1
- Set for op-batcher

### Batch Inbox

Address used to receive transaction on L1 for DA

- Seems to be derived by op-deployer (?)
- It's set on rollup.json (.batch_inbox_address) by op-deployer

## Proposer
Address used to submit state roots on L1

- User provided
- Private Key used to submit state roots from L2 to L1 (to disputeGameFactoryProxyAddress contract)
    - It calls create() method from disputeGameFactoryProxyAddress which creates a new contract on each call
- Funds required on L1

### PermissionedDisputeGameProxy

- Created by op-proposer
- Seems to be the targeted by op-proposer to submit proposals to the PermissionedDisputeGame contract


## Deployer / OP-Admin

- User provided
- Used by op-deployer to deploy / initialize network.
- Funds required on L1
- Calls OPCM (OP Contracts Manager) method Deploy (0x613e827b). This contract is predeployed on known networks. Contracts created are summarized below, **this is NOT an exhaustive list of available methods, only relevant ones are shown**.
  - Input:
    - roles (list of addresses: ProxyAdminOwner, ConfigOwner, batcher, proposer, signer, unsafeBlockSigner)
    - base fees
    - l2 chain id
    - gas limit
    - dispute-related params
  - Output (13 contracts created):
    - AddressManager
        - getAddress(string)(address)
        - setAddress(string,address)
    - ProxyAdmin
        - getProxyAdmin(_proxy address)(address)
        - getProxyImplementation(_proxy address)(address)
        - implementationName(address)(string)
        - setAddress(_name string, address)
        - setImplementationName(address, _name string)
        - upgrade(_proxy address, _implementation address)
    - l1ERC721BridgeProxyAddress
        - deposits(address, address,uint256)(bool)
        - bridgeERC721
        - bridgeERC721To
        - finalizeBridgeERC721
    - optimismPortalProxyAddress
        - disputeGame* functions
        - checkWithdrawal(_withdrawalHash bytes32, proofSubmitter address)
        - finalizedWithdrawals(bytes32)(bool)op-depl
        - finalizeWithdrawalTransaction
        - proveWithdrawalTransaction
    - systemConfigProxyAddress
        - *_SLOT()(bytes32)
        - read config methods (basefee, batcherhash, dispoptimismPortalProxyAddresstegamefactory, gaslimit, gastoken, startblock, etc)
        - setGasLimit(_gasLimit uint64)
    - optimismMintableERC20FactoryProxyAddress
        - createOptimismMintableERC20(remoteToken address, name string, symbol string)
        - createOptimismMintableERC20WithDecimals(remoteToken address, name string, symbol string, decimals uint8)
        - createStandardL2Token(remoteToken address, name string, symbol string)
    - disputeGameFactoryProxyAddress
        - findLatestGames
        - gameAtIndex
        - gameCount
        - gameImpls
        - games
        - getGameUUID
        - create
    - anchorStateRegistryProxyAddress
        - anchors(uint32)(root bytes32, l2BlockNumber uint256)
        - setAnchorState(game address)
    - l1StandardBridgeProxyAddress / L1ChugSplashProxy
        - deposits(address, address)(uint256)
        - bridgeERC20
        - bridgeERC20To
        - bridgeETH
        - bridgeETHTo
        - depositERC20
        - depositERC20To
        - depositETH
        - depositETHTo
        - finalizeBridgeERC20
        - finalizeBridgeETH
        - finalizeERC20Withdrawal
        - finalizeETHWithdrawal
    - l1CrossDomainMessengerProxyAddress
        - OVERHEAD functions ()(uint64)
        - messages functions
        - sendMessage
        - relayMessage
    - anchorStateRegistryImplAddress
        - anchors(uint32)(root bytes32, l2BlockNumber uint256)
        - setAnchorState(_game address)
    - delayedWETHPermissionedGameProxyAddress
        - ERC20 functions
    - permissionedDisputeGameAddress
        - game / challenge functions

Notes

- All the addresses for the contracts above can be retrieved with op-deployer: ```op-deployer inspect l1```


### Addresses found on rollup.json

- ```.genesis.system_config.batcherAddr``` --> Batcher address
- ```.batch_inbox_address``` --> Batch Inbox address
- ```.deposit_contract_address``` --> This matches the optimismPortalProxyAddress contract deployed by op-deployer Deploy() call
- ```.l1_system_config_address``` --> This matches the systemConfigProxyAddress contract deployed by op-deployer Deploy() call
- ```.protocol_versions_address``` --> This seems to be a contract managed by Optimism, with the only purpose of having a way to query recommended/required version on-chain


## zkEVM deployer / admin

Used to deploy contracts, it's usually set as contracts owner

## AggOracle

Address used to inject GERs

- User provided
- Funds required on L1
- Funds required on L2


## AggSender

Address used by Aggkit to submit certificates to Agglayer

- User provided
- Keystore used by Aggkit (AggSender) component
- Address set on Agglayer config on proof-signers section
- No funds required


## Agglayer

Address used to submit proofs to RollupManager

- User provided
- Keystore used by Agglayer component
- Funds required on L1
    - Used by Agglayer to submit proofs to RollupManager on L1
- Role TRUSTED_AGGREGATOR_ROLE required on RollupManager contract
    - ```cast send $ROLLUPMANAGER 'grantRole(bytes32,address)' $(cast keccak "TRUSTED_AGGREGATOR_ROLE") $AGGLAYER```

## ClaimTX

Address used by bridge-service to claim on L2

- User provided
- Funds required on L2


## Challenger

??

## unsafeblocksigner

??

