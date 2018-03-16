#!/bin/bash

function pause() {
  read -n1 -rsp $'...\n'
}

docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate

pause
echo "Setting Redis"
pause

set -x
docker exec redis redis-cli set foo foo
docker exec redis redis-cli set bar bar
docker exec redis redis-cli set baz baz
docker exec redis redis-cli set qux qux

set +x
pause
echo "Calling hosts based on dynamic routing"
pause
set -x

curl --user-agent foo localhost:80
curl --user-agent bar localhost:80
curl --user-agent baz localhost:80
curl --user-agent qux localhost:80
curl --user-agent foobar localhost:80
