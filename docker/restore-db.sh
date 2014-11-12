#!/bin/bash

docker ps | grep -q kithub_web
grep_status=$?

[[ $grep_status = 0 ]] && docker stop kithub_web > /dev/null

sh $(dirname ${BASH_SOURCE[0]})/cmd.sh sh ./docker/rails/setup_database.sh

[[ $grep_status = 0 ]] && docker start kithub_web > /dev/null
