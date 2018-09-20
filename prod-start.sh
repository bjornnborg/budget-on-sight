#!/bin/bash
echo "Starting"
docker-compose -f prod-docker-compose.yml start

ok=$?
if [ $ok -ne 0 ]; then
  echo "Building containers. May take a while"
  docker-compose -f prod-docker-compose.yml up -d
fi

echo "Done"
