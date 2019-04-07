#!/bin/bash

function pause() {
  read -n1 -rsp $'...\n'
}

docker-compose down
docker rm -f $(docker ps -a -q)
docker-compose up -d --force-recreate kong-db app
sleep 5

pause

echo "############################ Configuring Kong database"
pause
docker-compose run kong kong migrations bootstrap
docker-compose run kong kong migrations up
echo

echo "############################ Running Kong"
pause
docker-compose up -d --force-recreate kong
sleep 5
echo

echo "############################ Adding app as Kong service"
pause
(set -x; curl -i -X POST --url http://localhost:8001/services/ --data 'name=app-service' --data 'url=http://app')
echo
pause

echo "############################ Configuring Kong to proxy app"
pause
(set -x; curl -i -X POST --url http://localhost:8001/services/app-service/routes --data 'hosts[]=app.local')
echo
pause

echo "############################ Checking if Kong is proxying when header is present"
pause
(set -x; curl -i -X GET --url http://localhost:8000/ --header 'Host: app.local')
echo
pause

echo "############################ Checking if Kong is NOT proxying when header is absent"
pause
(set -x; curl -i -X GET --url http://localhost:8000/)
echo
pause

echo "############################ Running configuring Correlation ID plugin for our service"
pause
(set -x; curl -i -X POST --url http://localhost:8001/services/app-service/plugins --data "name=correlation-id" --data "config.header_name=correlation-id" --data "config.generator=uuid#counter" --data "config.echo_downstream=false")
echo
pause

echo "############################ Checking if correlation id is there"
pause
(set -x; curl -i -X GET --url http://localhost:8000/ --header 'Host: app.local')
echo
pause

echo "############################ Add some auth to our app"
pause
(set -x; curl -X POST http://localhost:8001/services/app-service/plugins --data "name=key-auth" --data "config.hide_credentials=false")
echo
pause

echo "############################ Create consumer"
pause
(set -x; curl -X POST http://localhost:8001/consumers/ --data "username=alice" --data "custom_id=alice-id")
echo
pause

echo "############################ Create API Key for Alice"
pause
(set -x; curl -s -X POST http://localhost:8001/consumers/alice/key-auth)
echo
pause

echo "############################ Checking if we still have access (remember to put proper api key)"
pause
(set -x; curl -i -X GET --url http://localhost:8000/ --header 'Host: app.local' --header 'apikey: ALICE_API_KEY_HERE')
echo
pause

#echo "############################ Calling app"
#pause
#(set -x; curl -o /dev/null --header "correlation-id: 0xCAFEBABE" -v localhost:8080)
#echo

#pause

#echo "############################ Calling proxy"
#pause
#(set -x; curl -o /dev/null --header "correlation-id: 0xCAFEBABE" -v localhost:80)

#pause

#firefox -private-window localhost:8080 &>/dev/null
#firefox -private-window localhost:80 &>/dev/null
