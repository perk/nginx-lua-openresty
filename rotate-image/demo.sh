#!/bin/bash

rm -rf app/usr/local/openresty/nginx/cache/*.jpg
rm -rf app/usr/local/openresty/nginx/cache/*.png

docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate #&& docker-compose logs --follow

firefox -private-window localhost:80 &>/dev/null
