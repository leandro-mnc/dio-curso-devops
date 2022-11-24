#!/bin/sh

WORKDIR="/vagrant"

sudo apt install nfs-common -y

# Add node to swarm
/bin/sh "$WORKDIR/swarm.sh"