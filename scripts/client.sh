#!/usr/bin/env bash

set -e

if [[ $# -ne 3 ]] ; then
    echo "Please provide: server_endpoint server_port server_public_key"
    exit 1
fi

server_endpoint=$1
server_port=$2
server_public_key=$3

sudo docker run --privileged kubewire client ${server_endpoint} ${server_port} ${server_public_key}

# TODO forward all your traffic through this container using iptables