FROM ruby:2.1

RUN apt-get update && apt-get install -y nodejs postgresql --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system
