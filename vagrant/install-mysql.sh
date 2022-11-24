#!/bin/sh

docker volume create meubanco

docker run --name meubanco -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=meubanco \
--mount type=volume,src=meubanco,dst=/var/lib/mysql -p 3306:3306 -d mysql:5.7

docker exec -i meubanco mysql -u root -pSenha123 meubanco < /vagrant/banco.sql