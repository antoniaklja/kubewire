#!/usr/bin/env bash

peer_endpoint=$1
peer_port=$2
peer_public_key=$3

if [[ $# -ne 3 ]] ; then
    echo "Please provide: peer_endpoint peer_port peer_public_key"
    exit 1
fi

# include `persistent-keepalive 25` for NAT
# https://www.wireguard.com/quickstart/#nat-and-firewall-traversal-persistence
wg set wg0 peer ${peer_public_key} allowed-ips 0.0.0.0/0 endpoint ${peer_endpoint}:${peer_port} persistent-keepalive 25

echo "Added new peer ${peer_endpoint}:${peer_port} ${peer_public_key}"