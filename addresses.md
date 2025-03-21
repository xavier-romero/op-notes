# Wallets

## Deployer

Address used by op-deployer to deploy / initialize network.

All the address below can be retrieved with op-deployer

    op-deployer inspect l1

- Calls OPCM (OP Contracts Manager) method Deploy (0x613e827b). This contract is predeployed on known networks.
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
        - finalizedWithdrawals(bytes32)(bool)
        - blacklistDisputeGame
        - depositTransaction
        - donateETH
        - finalizeWithdrawalTransaction
        - proveWithdrawalTransaction
    - systemConfigProxyAddress
        - *_SLOT()(bytes32)
        - read config methods (basefee, batcherhash, disputegamefactory, gaslimit, gastoken, startblock, etc)
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


## Sequencer

- Private Key used on op-node to sign transactions ????
- No funding required.


## Batcher

- Private Key used to send transaction batches to L1
- Funds required on L1


## Proposer

- Private Key used to submit state roots from L2 to L1
- Funds required on L1


