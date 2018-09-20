#!/bin/bash
echo "Updating"
docker-compose -f prod-docker-compose.yml pull && start
echo "Done"
