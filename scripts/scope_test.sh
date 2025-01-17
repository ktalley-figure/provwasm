#!/bin/bash -e

# This script stores and instantiates the scope smart contract for the metadata module
export PROV_CMD="./bin/provenanced"
PROV_CMD="./bin/provenanced"
WASM="./contracts/scope/artifacts/scope.wasm"
declare LOCAL_ARGS
if [ -z "${CI}" ]; then
  PROV_CMD=provenanced
  LOCAL_ARGS="--home build/run/provenanced"
  WASM=$1
fi

export node0=$("$PROV_CMD" keys show -a validator --keyring-backend test --testnet $LOCAL_ARGS)

"$PROV_CMD" tx name bind \
    "sc" \
    "$node0" \
    "pb" \
    --restrict=false \
    --from="$node0" \
    --keyring-backend test \
    --chain-id="testing" \
    --gas=auto \
	  --gas-prices="1905nhash" \
	  --gas-adjustment=1.5 \
    --broadcast-mode block \
    --yes \
    --testnet $LOCAL_ARGS

"$PROV_CMD" tx wasm store $WASM \
    --instantiate-only-address "$node0" \
    --from="$node0" \
    --keyring-backend test \
    --chain-id="testing" \
    --gas=auto \
	  --gas-prices="1905nhash" \
	  --gas-adjustment=1.5 \
    --broadcast-mode block \
    --yes \
    --testnet $LOCAL_ARGS

"$PROV_CMD" tx wasm instantiate 1 '{"name": "scope-itv2.sc.pb"}' \
    --admin "$node0" \
    --label metadata_module_integration_test_v2 \
    --from="$node0" \
    --keyring-backend test \
    --chain-id="testing" \
    --gas=auto \
	  --gas-prices="1905nhash" \
	  --gas-adjustment=1.5 \
    --broadcast-mode block \
    --yes \
    --testnet $LOCAL_ARGS

echo "done with the scope contract"