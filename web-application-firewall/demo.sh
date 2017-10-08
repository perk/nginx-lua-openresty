#!/bin/bash

function pause() {
  read -n1 -rsp $'...\n'
}


docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate

pause
echo "Running normal request"
pause
(set -x; curl 'http://localhost:80/?a=alert')

pause
echo "Running malicious request"
pause
(set -x; curl 'http://localhost:80/?a=alert(1)')

# ab -c 8 -n 10000 'http://localhost:80/?a=alert(1)'
# ab -c 8 -n 10000 'http://localhost:80/?a=alert'
# ab -c 8 -n 10000 'http://localhost:8080/'
