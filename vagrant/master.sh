#!/bin/sh

NODE=$1

IP_ADDR=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

WORKDIR="/vagrant"

# Clean log ip
rm "$WORKDIR/ip-nodes.log" 2> /dev/null
touch "$WORKDIR/ip-nodes.log"

sudo apt install nfs-kernel-server -y

# Install MYSQL
/bin/sh "$WORKDIR/install-mysql.sh"

# NFS
docker volume create app
echo '/var/lib/docker/volumes/app/_data *(rw,sync,subtree_check)' | sudo tee /etc/exports
sudo exportfs -ar
rsync -a --delete /vagrant/app/ /var/lib/docker/volumes/app/_data

# IP ADDRESS
echo "$IP_ADDR" >"$WORKDIR/ip-server.log"

# SWARM INIT
sudo docker swarm init --advertise-addr $IP_ADDR
TOKEN=$(sudo docker swarm join-token --quiet worker)
echo '#!/usr/bin/env bash' > "$WORKDIR/swarm.sh"
echo '' >> "$WORKDIR/swarm.sh"
echo "docker swarm join --token $TOKEN $IP_ADDR:2377" >> "$WORKDIR/swarm.sh"
sudo docker node update --availability drain $NODE