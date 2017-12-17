#!/usr/bin/env bash

set -e

docker rm -f kubewire-server || true
docker run --rm --name kubewire-server --privileged kubewire server