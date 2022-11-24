#!/bin/sh

NODE=$1

WORKDIR="/vagrant"

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker vagrant

sudo apt update && sudo apt install gawk -y

IP_ADDR=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

echo "$NODE = $IP_ADDR" >> "$WORKDIR/ip-nodes.log"
