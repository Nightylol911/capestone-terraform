#!/bin/sh

sudo apt-get update -yy
sudo apt-get install -yy git curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

wget https://raw.githubusercontent.com/Nightylol911/test-capstone/refs/heads/main/docker-compose.yml
printf "REDIS_HOST=${redis_host}\nDB_HOST=${db_host}\nDB_USER=user\nDB_PASSWORD=password\nDB_NAME=mydatabase\n" >> .env
until nc -vzw 2 ${db_host} 3306; do sleep 30; done
docker compose up -d flask-app
