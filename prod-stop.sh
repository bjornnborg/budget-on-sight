#!/bin/bash
echo "Stoping"
docker-compose -f prod-docker-compose.yml stop
echo "Done"
