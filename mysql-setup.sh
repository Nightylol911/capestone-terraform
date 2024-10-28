#!/bin/bash

sudo apt-get update -yy
sudo apt-get install -yy git curl

curl -fsSL https://get.docker.com/ -o get-docker.sh
sudo sh ./get-docker.sh

mkdir -p DB
docker run -d -p 3306:3306 --name mysql -v DB:/etc/init/conf.d -e MYSQL_ROOT_PASSWORD=rootpassword MYSQL_USER=user MYSQL_HOST=db MYSQL_PASSWORD=password MYSQL_NAME=mydatabase mysql