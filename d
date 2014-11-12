#!/bin/bash

export DOCKER_HOST="tcp://172.17.8.101:2375"
# export DOCKER_CERT_PATH=/Users/Jupiter/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=""

function check {
    if ! which docker > /dev/null; then
        echo "docker command not found\n"
        exit 1
    fi

    if ! docker ps > /dev/null; then
        echo "Can't connect to docker\n"
        exit 1
    fi
}

if [ $# -lt 1 ]
then
        echo "Usage : $0 command"
        echo "Commands:"
        echo "rc - Rails Console"
        echo "rdbm - Migrate Database"
        echo "restore-db - Restore db from db/current.sql.zip"
        echo "restart - Restart rails app after bundling gems"
        echo "rebuild - Rebuild the docker container with latest Gemfile and restart"
        echo 'cmd "bundle exec something" - Run the command in quotes in /app'
        #exit
fi

case "$1" in
shellinit)  #echo "Starting Console in Docker Container.."
    if [[ "$(basename -- "$0")" == "d" ]]; then
        echo "Don't run $0 shellinit, source it" >&2
        echo "> source d shellinit"
        exit 1
    else
        export DOCKER_HOST="tcp://172.17.8.101:2375"
        export DOCKER_TLS_VERIFY=""
    fi
    ;;
ssh)
    ssh core@localhost
    ;;
docker)  #echo "Starting Console in Docker Container.."
    docker "${@:2}"
    ;;
rc)  echo "Starting Console in Docker Container.."
    sh ./docker/rc.sh
    ;;
rdbm)  echo  "Running rake db:migrate in Docker container.."
    # vagrant ssh -c "sh /app/docker/scripts/rdbm.sh"
    ;;
restore-db)  echo  "Restoring db from db/current.sql.zip"
    sh ./docker/restore-db.sh
    ;;
rs) echo  "(Re)Starting Docker Rails Container"
    sh ./docker/restart.sh
   ;;
rebuild) echo  "Rebuilding Docker Rails Container"
    sh ./docker/rebuild.sh
   ;;
init)
    check
    echo "Starting database container"
    sh ./docker/start_postgres.sh
    echo "Building application container"
    sh ./docker/rebuild.sh
    echo "Bootstrapping database"
    sh ./docker/restore-db.sh
    echo "Starting server"
    sh ./docker/restart.sh
   ;;
# rebuild-base) echo  "Rebuilding Docker Rails Base Container"
#     echo "Building the base image can take some time."
#     sh ./docker/rebuild-base.sh
#    ;;
start-pg) echo  "Start Database Container"
    sh ./docker/start_postgres.sh
   ;;
cmd) echo "running '$2' in docker container in /usr/src/app"
    sh ./docker/cmd.sh "${@:2}"
    ;;
*) echo "Command not known"
   ;;
esac
