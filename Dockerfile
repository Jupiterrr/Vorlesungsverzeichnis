FROM ruby:2.0.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y nodejs --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    gem install foreman
# RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Old Gemfiles for better gem caching
ADD docker/Gemfile /usr/src/app/docker/Gemfile
ADD docker/Gemfile.lock /usr/src/app/docker/Gemfile.lock
RUN bundle install --gemfile /usr/src/app/docker/Gemfile --without development:test


ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --without development:test

ADD . /usr/src/app


EXPOSE 3000

CMD ["foreman", "start", "web"]