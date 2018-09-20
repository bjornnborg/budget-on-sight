#!/bin/bash
echo "Updating"
docker-compose pull && ./run.sh
echo "Done"
