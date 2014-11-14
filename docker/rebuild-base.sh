#!/bin/bash
cp Gemfile* docker/rails-base/
docker build -t kithub/rails-base ./docker/rails-base/
