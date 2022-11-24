#!/bin/sh

NODE=$1

IP_ADDR=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

WORKDIR="/vagrant"

if [ $NODE = "node01" ]; then
  # Create Service
  docker service rm meu-app 2>/dev/null
  docker service create --name meu-app --replicas 12 -p 80:80 --mount type=volume,src=app,dst=/app/ -dt webdevops/php-apache:7.2
else
  # Mount dir
  mount "$(cat "$WORKDIR/ip-server"):/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data"
fi

echo "$NODE has a ip address $IP_ADDR\n"