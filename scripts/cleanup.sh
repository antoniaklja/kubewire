#!/usr/bin/env bash

# Utility script to clean up changes make by `client.sh`

set -e

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

echo "Removing wireguard network interface and corresponding routes"
ip link del dev wg0