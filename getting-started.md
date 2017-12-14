# Getting started

Step by step guide how start with Kubewire.

## Docker images

Run server:

    ~/repo/kubewire/scripts$ ./server.sh 
    
    Running in server mode
    Enabling IPv4 Forwarding
    net.ipv4.conf.all.forwarding = 1
    Enabling IPv6 Forwarding
    net.ipv6.conf.all.disable_ipv6 = 0
    net.ipv6.conf.default.forwarding = 1
    net.ipv6.conf.all.forwarding = 1
    Generating server keys
    iAphOdB4314CvOBNlBTpDFDVSpSv86p0BpwQHuiX30I=
    Configuring wireguard
    Activating wireguard network interface
    Configuring route tables
    interface: wg0
      public key: iAphOdB4314CvOBNlBTpDFDVSpSv86p0BpwQHuiX30I=
      private key: (hidden)
      listening port: 5182

Run client:

    ~/repo/kubewire/scripts$ ./client.sh 172.17.0.2 5182 iAphOdB4314CvOBNlBTpDFDVSpSv86p0BpwQHuiX30I=
    
    Running in client mode
    Generating client keys
    Rz/UWjAy4A6AHidDjbReAET4r8nOdRjqyhFjyXWhmRs=
    Configuring wireguard
    Adding server 172.17.0.2:5182 peer iAphOdB4314CvOBNlBTpDFDVSpSv86p0BpwQHuiX30I=
    Activating wireguard network interface
    Configuring route tables
    Running
    interface: wg0
      public key: Rz/UWjAy4A6AHidDjbReAET4r8nOdRjqyhFjyXWhmRs=
      private key: (hidden)
      listening port: 5182

Add peer on server

    ~/repo/kubewire/docker$ sudo docker ps
    
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    83a6e53b915c        kubewire            "/usr/local/bin/en..."   6 minutes ago       Up 6 minutes        5182/udp            kickass_hopper

    ~/repo/kubewire/docker$ sudo docker inspect kickass_hopper | grep IPAddress
                "SecondaryIPAddresses": null,
                "IPAddress": "172.17.0.3",
    
    sudo docker exec kickass_hopper ./add_peer.sh 172.17.0.3 5182 Rz/UWjAy4A6AHidDjbReAET4r8nOdRjqyhFjyXWhmRs=

## Kubernetes

    TODO
