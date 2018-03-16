#!/bin/bash

function pause() {
  read -n1 -rsp $'...\n'
}

docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate

pause

echo "############################ Calling app"
pause
(set -x; curl -o /dev/null --header "correlation-id: 0xCAFEBABE" -v localhost:8080)
echo

pause

echo "############################ Calling proxy"
pause
(set -x; curl -o /dev/null --header "correlation-id: 0xCAFEBABE" -v localhost:80)

pause

firefox -private-window localhost:8080 &>/dev/null
#firefox -private-window localhost:80 &>/dev/null
