#!/bin/bash

# Wait for nodes to start
echo "Waiting for nodes to start..."
sleep 10

# Function to get node info
get_node_info() {
    local port=$1
    bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=$port getblockchaininfo
}

# Function to connect nodes
connect_nodes() {
    local from_port=$1
    local to_port=$2
    local from_addr=$(bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=$from_port getnodeaddresses | jq -r '.[0].address')
    bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=$to_port addnode $from_addr add
}

# Check if nodes are ready
echo "Checking node status..."
for port in 18444 18446 18448 18450; do
    while ! get_node_info $port >/dev/null 2>&1; do
        echo "Waiting for node on port $port..."
        sleep 5
    done
done

# Connect nodes in a mesh
echo "Connecting nodes..."
connect_nodes 18444 18446 # patched-1 -> patched-2
connect_nodes 18444 18448 # patched-1 -> legacy-1
connect_nodes 18444 18450 # patched-1 -> legacy-2
connect_nodes 18446 18448 # patched-2 -> legacy-1
connect_nodes 18446 18450 # patched-2 -> legacy-2
connect_nodes 18448 18450 # legacy-1 -> legacy-2

# Generate initial blocks on patched-1
echo "Generating initial blocks..."
bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=18444 generatetoaddress 101 $(bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=18444 getnewaddress)

# Check blockchain status
echo "Blockchain status:"
for port in 18444 18446 18448 18450; do
    echo "Node on port $port:"
    bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=$port getblockchaininfo | grep -E "blocks|headers"
done

echo "Regtest network is ready!"
