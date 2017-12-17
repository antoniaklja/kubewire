#!/usr/bin/env bash

set -e

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

echo "Enabling IPv4 Forwarding"
sysctl -w net.ipv4.conf.all.forwarding=1 || echo "Failed to enable IPv4 Forwarding"

# https://github.com/kylemanna/docker-openvpn/issues/40
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "Generating server keys"
wg genkey | tee /tmp/wg_private_key | wg pubkey

echo "Configuring wireguard"
ip link add dev wg0 type wireguard
wg set wg0 private-key /tmp/wg_private_key
wg set wg0 listen-port 5182
ip address add 10.0.0.0/16 dev wg0

echo "Activating wireguard network interface"
ip link set up dev wg0

# iptables rules to forward all of the incoming traffic from the private network to the outside world
echo "Routing all incoming traffic to the outside world"
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -A FORWARD -i wg0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/16 -o eth0 -j MASQUERADE

# keep running
echo "Running"
while true; do wg show wg0; sleep 60; done # FIXME maybe replace with supervisord?