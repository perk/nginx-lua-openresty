#!/bin/bash

function pause (){
  read -n1 -rsp $'...\n'
}

docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate

pause
echo
echo "###################################"
echo "Benchmark app through docker proxy"
pause
(set -x; ab -c 8 -n 50000 http://localhost:8088/)

pause
echo
echo "###################################"
echo "Benchmark app through host network"
pause
(set -x; ab -c 8 -n 50000 http://localhost:8080/)

pause
echo
echo "###################################"
echo "Benchmark proxy without lua"
pause
(set -x; ab -c 8 -n 50000 http://localhost:80/simple)

pause
echo
echo "###################################"
echo "Benchmark proxy with lua"
pause
(set -x; ab -c 8 -n 50000 http://localhost:80/)
