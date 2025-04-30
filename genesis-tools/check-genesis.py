import json
import sys

if len(sys.argv) != 2:
    print("Usage: python check-balance.py <filename>")
    sys.exit(1)

INFOS = []
WARNS = []
ERRORS = []
PREMINTED = {}
CONTRACTS = {}
with open('known_contracts.json', 'r') as f:
    KNOWN_CONTRACTS = json.load(f)


def check_hex_str(s):
    if not s:
        return "0x0"
    if not isinstance(s, str):
        raise TypeError(f"Expected string, got {type(s)}")
    if not s.startswith('0x'):
        return hex(int(s))
    if s == '0x':
        return "0x0"
    try:
        int(s, 16)
    except ValueError:
        raise

    return s


def check_balance_for_address(address, balance):
    balance = check_hex_str(balance)

    if balance == '0x1':
        address_int = int(address, 16)
        # check address_int is between 0 and 0xff
        if not (0 <= address_int <= 0xff):
            ERRORS.append(f"Address: {address} has unexpected balance: 1")
            return False
        else:
            return True
    elif balance == '0x0':
        return True
    else:
        WARNS.append(f"Address: {address} has a non-zero balance: {balance}")
        PREMINTED[address] = balance
        return False


def check_nonce_for_address(address, nonce):
    nonce = check_hex_str(nonce)

    if nonce == '0x0':
        return True
    else:
        INFOS.append(f"Address: {address} has a non-zero nonce: {nonce}")
        return False


def check_code_for_address(address, code):
    code = check_hex_str(code)

    if code != "0x0":
        CONTRACTS[address] = code


def check_duplicate_contracts(contracts: dict):
    already_seen = []
    for address, code in contracts.items():
        if address in already_seen:
            continue
        _addressess = [x for x in contracts.keys() if contracts[x] == code]
        already_seen.extend(_addressess)
        if len(_addressess) > 1:
            WARNS.append(
                f"Address: {address} has same code as: {_addressess}"
            )


filename = sys.argv[1]
with open(filename, 'r') as file:
    data = json.load(file)

alloc = data.get('alloc', {})
if not alloc:
    print("No 'alloc' key found in the JSON file.")
    sys.exit(1)

# MAIN CHECK LOOP
for address, address_info in alloc.items():
    balance = address_info.get('balance')
    if balance:
        check_balance_for_address(address, balance)
    else:
        WARNS.append(f"Address: {address} does not have a balance key.")

    nonce = address_info.get('nonce')
    if nonce:
        check_nonce_for_address(address, nonce)

    code = address_info.get('code')
    if code:
        check_code_for_address(address, code)

# Check for duplicate contracts
_contracts = {
    k: v for k, v in CONTRACTS.items()
    if not k.startswith('4200000000000000000000000000000000000')
}
check_duplicate_contracts(_contracts)

# Interesting contracts
interesting_contracts = {}
for k, v in CONTRACTS.items():
    k = k.lower()
    v = v.lower()

    if k.startswith('4200000000000000000000000000000000000'):
        continue
    if k.startswith('c0d3c0d3c0d3c0d3c0d3c0d3c0d3c0d3c0d300'):
        continue

    # locate key for known contract with same code
    for known_key, known_value in KNOWN_CONTRACTS.get("by_code").items():
        known_value = known_value.lower()
        if v == known_value:
            if interesting_contracts.get(k):
                interesting_contracts[k] = \
                    interesting_contracts[k] + " | " + known_key
            else:
                interesting_contracts[k] = known_key

    # locate key for known address contracts
    for known_key, known_value in KNOWN_CONTRACTS.get("by_address").items():
        known_value = known_value.lower()
        if k == known_value:
            if interesting_contracts.get(k):
                interesting_contracts[k] = \
                    interesting_contracts[k] + " | " + known_key
            else:
                interesting_contracts[k] = known_key

    if k not in interesting_contracts:
        interesting_contracts[k] = "Unknown"


result = {
    "errors": ERRORS,
    "warnings": WARNS,
    "infos": INFOS,
    "preminted": PREMINTED,
    "contracts": interesting_contracts,
}
print(json.dumps(result, indent=4))
