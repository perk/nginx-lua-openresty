#!/bin/bash

function pause() {
      read -n1 -rsp $'...\n'
}

docker-compose down
docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate

pause
echo
echo "###################################"
echo "Diff between configuration"
pause
diff app/usr/local/openresty/nginx/conf/nginx-1024.conf app/usr/local/openresty/nginx/conf/nginx.conf

pause
echo
echo "###################################"
echo "Nginx with 1 worker"
pause
for f in {1..30}; do curl localhost:80; done

pause
echo
echo "###################################"
echo "Nginx with 1024 workers"
pause
for f in {1..30}; do curl localhost:88; done
