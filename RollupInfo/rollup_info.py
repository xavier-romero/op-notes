#!/usr/bin/python3
import sys
from web3 import Web3
from constants import abis, info, BLOCK_RANGE

if len(sys.argv) != 3:
    print("Usage: python rollup_info.py <l1_rpc> <bali|cardona|mainnet>")
    sys.exit(1)

l1_rpc_url = sys.argv[1]
rm_address = info[sys.argv[2]]["rollup_manager_address"]
rm_block = info[sys.argv[2]]["rollup_manager_block"]
rm_abi = abis["PolygonRollupManager"]

web3_l1 = Web3(Web3.HTTPProvider(l1_rpc_url))
rm_contract = web3_l1.eth.contract(address=rm_address, abi=rm_abi)


def get_events(from_block, to_block):
    _events = []
    for event_abi in rm_contract.events._events:
        event_type = getattr(rm_contract.events, event_abi["name"])
        logs = event_type.get_logs(from_block=from_block, to_block=to_block)
        _events.extend(logs)

    print(f"Fethed {len(_events)} events from block {from_block} to {to_block}")
    return _events

    # # Get the event object
    # event = getattr(contract.events, "VerifyBatchesTrustedAggregator")

    # # Fetch the event logs
    # event_filter = event.create_filter(from_block=from_block, to_block=to_block)
    # return event_filter.get_all_entries()


events = []
current_block = web3_l1.eth.block_number

start_block = rm_block
end_block = min(rm_block + BLOCK_RANGE, current_block)

while start_block < current_block:
    events.extend(get_events(start_block, end_block))
    start_block = end_block + 1
    end_block = min(start_block + BLOCK_RANGE, current_block)
    print(f"Remaining blocks: {current_block - start_block}")

# for event in events:
#     event_args = event.args
#     event_tx_hash = event.transactionHash.hex()
#     event_block_number = event.blockNumber
# print(events[0].args)

