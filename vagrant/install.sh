#!/bin/sh

# docker service create --name meu-app --replicas 12 -p 80:80 --mount type=volume,src=app,dst=/app/ -dt webdevops/php-apache:7.2
# docker service create --name meu-app --replicas 12 -p 80:80 --mount type=volume,src=app,dst=/usr/local/apache2/htdocs/ -dt httpd
# showmount -e 10.0.0.171
# mount 10.0.0.171:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data

NAME=$1

WORKDIR="/vagrant"

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker vagrant

sudo apt update && sudo apt install gawk -y

IP_ADDR=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

if [ $NAME = "node01" ]; then
  sudo apt install nfs-kernel-server -y

  # Install MYSQL
  /bin/sh "$WORKDIR/install-mysql.sh"

  # NFS
  docker volume create app
  echo '/var/lib/docker/volumes/app/_data *(rw,sync,subtree_check)' | sudo tee /etc/exports
  sudo exportfs -ar
  rsync -a --delete /vagrant/app/ /var/lib/docker/volumes/app/_data

  # IP ADDRESS
  echo "$IP_ADDR" >"$WORKDIR/ip-server"

  # SWARM INIT
  sudo docker swarm init --advertise-addr $IP_ADDR
  TOKEN=$(sudo docker swarm join-token --quiet worker)
  echo '#!/usr/bin/env bash' > "$WORKDIR/swarm.sh"
  echo '' >> "$WORKDIR/swarm.sh"
  echo "docker swarm join --token $TOKEN $IP_ADDR:2377" >> "$WORKDIR/swarm.sh"
  sudo docker node update --availability drain $NODE
else
  sudo apt install nfs-common -y

  # Add node to swarm
  /bin/sh "$WORKDIR/swarm.sh"
fi

hostnamectl hostname $NAME
