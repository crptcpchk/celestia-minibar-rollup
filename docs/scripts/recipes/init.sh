#!/bin/sh

VALIDATOR_NAME=validator1
CHAIN_ID=minibar
KEY_NAME=minibar-key
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000000000stake"
STAKING_AMOUNT="1000000000stake"

NAMESPACE_ID=$(openssl rand -hex 8)
echo $NAMESPACE_ID
DA_BLOCK_HEIGHT=$(curl https://rpc-blockspacerace.pops.one/block | jq -r '.result.block.header.height')
echo $DA_BLOCK_HEIGHT

ignite chain build
minibard tendermint unsafe-reset-all
minibard init $VALIDATOR_NAME --chain-id $CHAIN_ID

minibard keys add $KEY_NAME --keyring-backend test
minibard add-genesis-account $KEY_NAME $TOKEN_AMOUNT --keyring-backend test
minibard gentx $KEY_NAME $STAKING_AMOUNT --chain-id $CHAIN_ID --keyring-backend test
minibard collect-gentxs
minibard start --rollkit.aggregator true --rollkit.da_layer celestia --rollkit.da_config='{"base_url":"http://localhost:26659","timeout":60000000000,"fee":6000,"gas_limit":6000000}' --rollkit.namespace_id $NAMESPACE_ID --rollkit.da_start_height $DA_BLOCK_HEIGHT
