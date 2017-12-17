# [WIP] Kubewire

Self hosted secure and scalable VPN based on [WireGuard](https://www.wireguard.com) with Kubernetes integration.

    WireGuard is a secure network tunnel, operating at layer 3, implemented as a kernel virtual network
    interface for Linux, which aims to replace both IPsec for most use cases, as well as popular user space and/or
    TLS-based solutions like OpenVPN, while being more secure, more performant, and easier to use
    
For more information please take a look at [Whitepaper](https://www.wireguard.com/papers/wireguard.pdf)    
    

## Roadmap

Current: Proof of Concept, client and server are working

Phase 1: Easy deployment on Kubernetes, better configuration 

Phase 2: Web UI integrated with SSO using [oauth2_proxy](https://github.com/bitly/oauth2_proxy)

Phase 3: Client running in userspace, integration with Kubernetes

## Installation 

There are various ways of installing Kubewire.
Please take a look at [getting-started](getting-started.md) section for more details.

## Troubleshooting

If creating a new link returns

    # ip link add dev wg0 type wireguard
    RTNETLINK answers: Operation not supported

you probably miss the `wireguard-dkms` and `wireguard-tools` packages on host.


If DNS resoultion doesn't work, check

    cat /etc/resolv.conf
    
    
If `network is unreachable` remove wireguard network interface

    ip link del dev wg0    

## Reporting a security vulnerability

In case of any concerns or real vulnerability do not hesitate to open an issue.

## Contribute

If you have any idea for an improvement or found a bug don't hesitate to open an issue or just make a pull request!




