#!/bin/bash
./run.sh && docker-compose exec -e "RAILS_ENV=test" rails-one bundle exec rspec -fd
