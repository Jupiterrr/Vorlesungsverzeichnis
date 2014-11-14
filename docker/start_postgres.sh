#!/bin/bash

docker rm -f kithub_db
docker run -d --name kithub_db -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker postgres:latest
