#!/bin/bash

docker rm -f kithub_web &> /dev/null
# docker run -t -i -p 3000:3000 -v $(pwd):/usr/src/app --link kithub_db:db --name kithub_web kithub/rails:latest bundle exec rails s thin
# docker run -d -p 3000:3000 --link kithub_db:db -v /home/core/share/:/usr/src/app/ --name kithub_web kithub/rails:latest bundle exec rails s thin

rm tmp/pids/server.pid &> /dev/null

ip=$(boot2docker ip 2> /dev/null)
echo "Application starting on http://$ip:3000"
docker run -ti -p 3000:3000 --link kithub_db:db -v /home/docker/share/:/usr/src/app/ --name kithub_web kithub/rails:latest bundle exec rails s thin
