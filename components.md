# Components

## op-geth

[Configuration options](https://docs.optimism.io/operators/node-operators/configuration/execution-config)

**Execution layer**

- Executes L2 transactions
- Maintain L2 state and mempool

Exposed API/ports:

- 8545, standard RPC-JSON API
- 8546, standard WS-RPC (ws.port)
- 8551, authenticated API (authrpc.port)

Dependencies

- None


## op-node

[Configuration options](https://docs.optimism.io/operators/node-operators/configuration/consensus-config)

**Sequencer + Consensus layer**

- Derives L2 chain from L1
- Track L1 and syncs L2 based on it
- Generate new blocks

Exposed API/ports:

- 9545, [Rollup RPC](https://docs.optimism.io/operators/node-operators/json-rpc#op-node) (rpc.port)

Dependencies

- *op-geth* AuthRPC
- L1 JSON-RPC + Beacon API
- File rollup.json
- (1) Sequencer Private Key

Notes

- Block time is set in the *rollup.json* file, it is NOT a config parame
- Param ```--l2``` needs to point to *op-geth* AuthRPC port (```--authrpc.port``` option on *op-geth*)
- Param ```--l2.jwt-secret``` points to the same file than ```--authrpc.jwtsecret``` on *op-geth*
- (1) Sequencer Key is only required for signing P2P, if you don't set P2P you don't even need to provide this key


## op-batcher

[Configuration options](https://docs.optimism.io/operators/chain-operators/configuration/batcher#global-options)

**Send transaction batches from L2 to L1**

- Gather L2 txs from op-geth
- Build batches of transactions
- Submit batches to L1 (destination: Batch Inbox address)

Exposed API/ports:

- 8548, Admin RPC ?? (rpc.port)

Dependencies

- Rollup RPC (op-node)
- L2 JSON-RPC (op-geth)
- L1 JSON-RPC
- Batcher Private Key

Notes

- By default, it commits to L1 through data on regular txs, however you can use BLOBS by setting flag ```--data-availability-type=blobs```

## op-proposer

[Configuration options](https://docs.optimism.io/operators/chain-operators/configuration/proposer#global-options)

**Submit state roots (L2 output) to L1**

- Post to the **L2OutputOracle** contract
- With OP Succint, submits ZK proofs for L2 outputs

Exposed API/ports:

- 8560, Admin RPC ?? (rpc.port)

Dependencies

- Either DisputeGameFactory or L2OutputOracle ????
- L1 JSON-RPC
- Proposer Private Key
- *L2OutputOracleProxy* or *disputeGameFactoryProxyAddress* address
