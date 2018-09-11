FROM ruby:2.4-alpine
#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
#RUN apk add --update alpine-sdk mariadb-dev
RUN apk add --update --no-cache \
  bash \
  build-base \
  linux-headers \
  nodejs \
  tzdata \
  mariadb-dev


ENV RAILS_ROOT /budget-on-sight
RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile $RAILS_ROOT/Gemfile
#COPY Gemfile.lock $RAILS_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install
COPY . $RAILS_ROOT
RUN chmod +x rails-init.sh
ENTRYPOINT ./rails-init.sh
