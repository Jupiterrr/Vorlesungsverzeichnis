
column-view:
	rm -rf app/assets/components/column-view
	cp -r ../../colum-view-bower/dist/ app/assets/components/column-view

start-elastic:
	elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
