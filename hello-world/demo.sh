#!/bin/bash

docker-compose down
docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate

curl localhost:80
