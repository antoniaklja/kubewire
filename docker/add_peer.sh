#!/usr/bin/env bash

peer_endpoint=$1
peer_port=$2
peer_public_key=$3

if [[ $# -ne 3 ]] ; then
    echo "Please provide: peer_endpoint peer_port peer_public_key"
    exit 1
fi

wg set wg0 peer ${peer_public_key} allowed-ips ${peer_endpoint}/32 endpoint ${peer_endpoint}:${peer_port}

echo "Added new peer ${peer_endpoint}:${peer_port} ${peer_public_key}"