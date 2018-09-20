#!/bin/bash
echo "Starting"
docker-compose start

ok=$?
if [ $ok -ne 0 ]; then
  echo "Building containers. May take a while"
  docker-compose up -d
fi

echo "Done"
