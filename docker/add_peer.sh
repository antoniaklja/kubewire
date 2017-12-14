#!/usr/bin/env bash

peer_endpoint=$1
peer_port=$2
peer_public_key=$3

wg set wg0 peer ${peer_public_key} allowed-ips 0.0.0.0/0 endpoint ${peer_endpoint}:${peer_port}
echo "Added new peer ${peer_endpoint}:${peer_port} ${peer_public_key}"