require 'elasticsearch'
require 'typhoeus/adapters/faraday'

class KithubIndexer

  def index!(client=Rails.application.config.elasticsearch_client)
    set_analyzer(client)
    EventIndexer.new.index!(client)
    VvzIndexer.new.index!(client)
    PoiIndexer.new.index!(client)
  end

  def set_analyzer(client)
    client.indices.delete(index: "kithub") rescue nil
    mapping = JSON.parse(IO.read(File.expand_path("../mapping.json", __FILE__)))
    client.indices.create(index: "kithub", body: mapping)
  end

  module IndexHelper
    def index_hash(type, id, data)
      { index:  { _index: 'kithub', _type: type.to_s, _id: id, data: data } }
    end
  end

end

require_relative "indexer/event_indexer"
require_relative "indexer/vvz_indexer"
require_relative "indexer/poi_indexer"
