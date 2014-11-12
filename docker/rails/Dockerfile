FROM kithub/rails-base

WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system

# Add . /usr/src/app/
