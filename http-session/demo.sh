#!/bin/bash

docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate #&& docker-compose logs --follow

firefox -private-window localhost:80 &>/dev/null
