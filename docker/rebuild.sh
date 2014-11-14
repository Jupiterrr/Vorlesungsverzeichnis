#!/bin/bash

cp Gemfile* docker/rails/
docker build -t kithub/rails docker/rails/
# docker build -t kithub/rails .

sh $(dirname ${BASH_SOURCE[0]})/restart.sh
