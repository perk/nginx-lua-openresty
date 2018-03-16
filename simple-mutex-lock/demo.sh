#!/bin/bash

docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate #&& docker-compose logs --follow

curl localhost:80/t
