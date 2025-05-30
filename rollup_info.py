#!/usr/bin/python3
from web3 import Web3
from abis import abis

l1_rpc_url = "https://sepolia.gateway.tenderly.co/xxxxxxxxxx"
rm_address = "0x24F645508e47c8988CE8A8d8B85fb2d84abbB096"

rm_abi = abis["PolygonRollupManager"]

# RM: 0x24F645508e47c8988CE8A8d8B85fb2d84abbB096
# PP R: 0xc226598be3a4771b38264E93e525Ae4BE11387eF
# FEP R: 0x39829015291966f08246b5C9f073c4aeAfa308d3

# FROM FEP:
# SEPOLIA_FUNDED_ADDR=""
# POLTOKENADDR="0x21728e8c9D451B66EAaFF0254B509c44b2C9174B"
# BRIDGE_ADDR="0xef5C08f2c24a585b68B30fD5449c6BE2C10bd0dC"
# L2_BRIDGE_ADDR="0xef5C08f2c24a585b68B30fD5449c6BE2C10bd0dC"
# L2_GERMANAGER_ADDR="0xa40d5f56745a118d0906a34e69aec8c0db1cb8fa"
# ROLLUP_ADDR="0x39829015291966f08246b5C9f073c4aeAfa308d3"
# AGGLAYER_GW_ADDR="0xA38e1500fCa45051da30Ac82BE2b29520e649C63"

# FROM PP:
# SEPOLIA_FUNDED_ADDR=""
# L2_BRIDGE_ADDR="0xef5C08f2c24a585b68B30fD5449c6BE2C10bd0dC"
# L2_GERMANAGER_ADDR="0xa40d5f56745a118d0906a34e69aec8c0db1cb8fa"
# POLTOKENADDR="0x21728e8c9D451B66EAaFF0254B509c44b2C9174B"
# BRIDGE_ADDR="0xef5C08f2c24a585b68B30fD5449c6BE2C10bd0dC"
# ROLLUP_ADDR="0xc226598be3a4771b38264E93e525Ae4BE11387eF"
# AGGLAYER_GW_ADDR="0xA38e1500fCa45051da30Ac82BE2b29520e649C63"

# Connect to the Ethereum node
web3_l1 = Web3(Web3.HTTPProvider(l1_rpc_url))


def get_contract_events(from_block, to_block):
    """
    Retrieve events from an Ethereum smart contract.
    :param abi: ABI of the smart contract
    :param event_name: Name of the event to retrieve
    :param from_block: Starting block number
    :param to_block: Ending block number
    :return: List of event logs
    """

    if not web3_l1.is_connected():
        raise ConnectionError("Failed to connect to the Ethereum node.")

    # Load the contract
    contract = web3_l1.eth.contract(address=rm_address, abi=rm_abi)

    # Get the event object
    event = getattr(contract.events, "VerifyBatchesTrustedAggregator")

    # Fetch the event logs
    event_filter = event.create_filter(from_block=from_block, to_block=to_block)
    return event_filter.get_all_entries()

events = get_contract_events(8416803, 8440130)
for event in events:
    event_args = event.args
    event_tx_hash = event.transactionHash.hex()
    event_block_number = event.blockNumber
print(events[0].args)