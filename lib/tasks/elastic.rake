

namespace :elastic do

  # desc "Create a database dump (options: file=db/db.dump, database=vvz_dev)"
  task :test do |t, args|
    require "search/elastic_kithub_search"
    client = Elasticsearch::Client.new log: false
    ap ElasticKithubSearch.new(client).search_all("Computergrafik")
  end

  task :index => :environment do |t, args|
    require "search/indexer"
    KithubIndexer.new.index!
  end

end


# To have launchd start elasticsearch at login:
#     ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
# Then to load elasticsearch now:
#     launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
# Or, if you don't want/need launchctl, you can just run:
#     elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
