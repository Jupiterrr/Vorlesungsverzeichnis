#!/bin/bash
docker run -i -t --rm -v /home/docker/share/:/usr/src/app/ --link kithub_db:db kithub/rails:latest "$@"

