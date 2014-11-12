#!/bin/sh

set -u # prevent unbound variables
set -e # terminate on error

#
# Check for docker
#
if test ! $(which docker)
then
  echo "  docker cammand not found!"
  exit
fi

#
# Check for database
#

if ! $(docker ps -f status=running | grep -q kithub_db)
then
  echo "  postgress is not running"
  echo "  run docker ..."
fi

