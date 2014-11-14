#!/bin/bash

set -u # prevent unbound variables
# set -e # terminate on error


function check {
    if ! which docker &> /dev/null; then
        echo "docker command not found"
        exit 1
    fi

    if ! docker ps &> /dev/null; then
        echo "Can't connect to docker"
        #exit 1
    fi
}

if which boot2docker &> /dev/null; then
    mount_target="/home/docker/share/"
else
    mount_target=$(pwd)
fi


function cmd {
    echo "mount: $mount_target"
    docker run -i -t --rm -v $mount_target:/usr/src/app/ --link kithub_db:db kithub/rails:latest $1
}

function restart {
    echo "mount: $mount_target"
    docker rm -f kithub_web &> /dev/null
    rm -f $mount_target/tmp/pids/server.pid &> /dev/null
    if which boot2docker &> /dev/null; then
        local ip=$(boot2docker ip 2> /dev/null)
    else
        local ip="localhost"
    fi
    
    echo "Application starting on http://$ip:3000"
    docker run -ti -p 3000:3000 --link kithub_db:db -v $mount_target:/usr/src/app/ --name kithub_web kithub/rails:latest bundle exec rails s thin
}

function sync {
    port=$(boot2docker config 2>&1 | awk '/SSHPort/ {print $3}')
    rsync -rlz --exclude-from=.rsyncignore -e "ssh -i /Users/Jupiter/.ssh/id_boot2docker -p $port" --force --delete ./ docker@localhost:/home/docker/share
    date
}

function active_sync {
    sync
    fswatch -o . | xargs -n1 -I{} sync
}

function start_db {
    docker rm -f kithub_db &> /dev/null
    docker run -d --name kithub_db -e POSTGRESQL_USER=docker -e POSTGRESQL_PASS=docker postgres:latest
}

function restore_db {
    if docker ps | grep -q kithub_web; then
        grep_status=0
    else
        grep_status=1
    fi
    [[ $grep_status = 0 ]] && docker stop kithub_web &> /dev/null || true
    cmd "sh ./docker/rails/setup_database.sh" || true
    [[ $grep_status = 0 ]] && docker start kithub_web &> /dev/null || true
}

function rebuild {
    cp Gemfile* docker/rails/
    docker build -t kithub/rails docker/rails/
}

function rebuild_base {
    cp Gemfile* docker/rails-base/
    docker build -t kithub/rails-base ./docker/rails-base/
}

function rails_console {
    cmd "bundle exec rails c"
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
ssh)
    ssh core@localhost
    ;;
docker)  #echo "Starting Console in Docker Container.."
    docker "${@:2}"
    ;;
rc)  echo "Starting Console in Docker Container.."
    # sh ./docker/rc.sh
    rails_console
    ;;
rdbm)  echo  "Running rake db:migrate in Docker container.."
    # vagrant ssh -c "sh /app/docker/scripts/rdbm.sh"
    ;;
restore-db)  echo  "Restoring db from db/current.sql.zip"
    # sh ./docker/restore-db.sh
    restore_db
    ;;
rs) echo  "(Re)Starting Docker Rails Container"
    # sh ./docker/restart.sh
    restart
   ;;
rebuild) echo  "Rebuilding Docker Rails Container"
    # sh ./docker/rebuild.sh
    rebuild
   ;;
init)
    check
    echo "Starting database container"
    #sh ./docker/start_postgres.sh
    start_db
    echo "Building application container"
    # sh ./docker/rebuild.sh
    rebuild
    echo "Bootstrapping database"
    # sh ./docker/restore-db.sh
    restore_db
    echo "Starting server"
    restart
   ;;
# rebuild-base) echo  "Rebuilding Docker Rails Base Container"
#     echo "Building the base image can take some time."
#     # sh ./docker/rebuild-base.sh
#     rebuild_base
#    ;;
start-pg) echo  "Start Database Container"
    # sh ./docker/start_postgres.sh
    start_db
   ;;
cmd) echo "running '$2' in docker container in /usr/src/app"
    # sh ./docker/cmd.sh "${@:2}"
    x=${@:2}
    cmd "$x"
    ;;
sync)
    active_sync
    ;;
*) echo "Command not known"
   ;;
esac
