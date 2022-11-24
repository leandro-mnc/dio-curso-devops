#!/bin/sh

sudo docker volume create meubanco

sudo docker build -f /vagrant/docker/mysql/Dockerfile -t meubanco:latest /vagrant/.

sudo docker run --name meubanco -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=meubanco \
--mount type=volume,src=meubanco,dst=/var/lib/mysql -p 3306:3306 -d meubanco:latest