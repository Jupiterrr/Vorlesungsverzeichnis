#!/bin/bash
docker run -i -t --rm -v /home/core/share/:/usr/src/app/ --link kithub_db:db kithub/rails:latest "$@"
