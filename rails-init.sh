#!/bin/bash

echo "================================="
echo "Starting rails application script"
echo "================================="

echo "Waiting for mysql"
echo "-----------------"
while ! nc -z mysql-service 3306; do sleep 2; done

echo "Creating database"
echo "-----------------"
bundle exec rails db:create

echo "Migrating database"
echo "------------------"
bundle exec rails db:migrate

echo "Starting server"
echo "---------------"
bundle exec rails s -p 3000 -b '0.0.0.0'
