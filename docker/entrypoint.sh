#!/usr/bin/env bash

set -e

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

mode=$1
server_endpoint=${2:-}
server_port=${3:-}
server_public_key=${4:-}

if [[ ${mode} != "client" && ${mode} != "server" ]] ; then
    echo "Please provide correct mode: server or client"
    exit 1
fi

echo "Running in ${mode} mode"

if [[ ${mode} == "server" ]] ; then
    echo "Enabling IPv4 Forwarding"
    sysctl -w net.ipv4.conf.all.forwarding=1 || echo "Failed to enable IPv4 Forwarding"

    echo "Enabling IPv6 Forwarding"
    sysctl -w net.ipv6.conf.all.disable_ipv6=0 || echo "Failed to enable IPv6 support"
    sysctl -w net.ipv6.conf.default.forwarding=1 || echo "Failed to enable IPv6 Forwarding default"
    sysctl -w net.ipv6.conf.all.forwarding=1 || echo "Failed to enable IPv6 Forwarding"

    # https://github.com/kylemanna/docker-openvpn/issues/40
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi

echo "Generating ${mode} keys"
wg genkey | tee /tmp/wg_private_key | wg pubkey

echo "Configuring wireguard"
ip link add dev wg0 type wireguard
wg set wg0 private-key /tmp/wg_private_key
wg set wg0 listen-port 5182
if [[ ${mode} == "server" ]] ; then
    ip address add 10.0.0.1/24 dev wg0
else
    ip address add 10.0.0.2/24 dev wg0
fi

if [[ ${mode} == "client" ]] ; then
    echo "Adding server ${server_endpoint}:${server_port} peer ${server_public_key}"
    wg set wg0 peer ${server_public_key} allowed-ips 0.0.0.0/0 endpoint ${server_endpoint}:${server_port}
fi

echo "Activating wireguard network interface"
ip link set up dev wg0

echo "Configuring route tables"
if [[ ${mode} == "client" ]] ; then
    default_gateway=$(ip route | awk '/default/ { print $3 }')
    ip route del default
    ip route add default dev wg0
    ip route add ${server_endpoint}/32 via ${default_gateway} dev eth0
fi
# TODO configure route table in server mode

# keep running
echo "Running"
while true; do wg show wg0; sleep 120; done # FIXME replace with supervisord?