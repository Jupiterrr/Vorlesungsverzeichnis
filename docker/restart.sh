docker rm -f kithub_web
# docker run -t -i -p 3000:3000 -v $(pwd):/usr/src/app --link kithub_db:db --name kithub_web kithub/rails:latest bundle exec rails s thin
docker run -d -p 3000:3000 --link kithub_db:db -v /home/core/share/:/usr/src/app/ --name kithub_web kithub/rails:latest bundle exec rails s thin
echo "Application starting on http://172.17.8.101:3000"
echo "It can take a few seconds until it is ready."
