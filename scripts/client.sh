#!/usr/bin/env bash

set -e

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

if [[ $# -ne 3 ]] ; then
    echo "Please provide: server_endpoint server_port server_public_key"
    exit 1
fi

clean_up() {
	# Perform program exit housekeeping
	echo "Removing wireguard network interface and corresponding routes"
    ip link del dev wg0
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM

server_endpoint=$1
server_port=$2
server_public_key=$3

echo "Generating server keys"
wg genkey | tee /tmp/wg_private_key | wg pubkey

echo "Configuring wireguard"
ip link del dev wg0 2>/dev/null || true
ip link add dev wg0 type wireguard
wg set wg0 private-key /tmp/wg_private_key
wg set wg0 listen-port 5182
ip address add 10.1.0.0/16 dev wg0

echo "Activating wireguard network interface"
ip link set up dev wg0

echo "Adding server ${server_endpoint}:${server_port} peer ${server_public_key}"
# include `persistent-keepalive 25` for NAT
# https://www.wireguard.com/quickstart/#nat-and-firewall-traversal-persistence
wg set wg0 peer ${server_public_key} allowed-ips 0.0.0.0/0 endpoint ${server_endpoint}:${server_port} persistent-keepalive 25

echo "Configuring route tables"
host="$(wg show wg0 endpoints | sed -n 's/.*\t\(.*\):.*/\1/p')"
ip route add $(ip route get $host | sed '/ via [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/{s/^\(.* via [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/}' | head -n 1) 2>/dev/null || true
ip route add 0/1 dev wg0
ip route add 128/1 dev wg0

# keep running
echo "Running"
while true; do wg show wg0; sleep 60; done