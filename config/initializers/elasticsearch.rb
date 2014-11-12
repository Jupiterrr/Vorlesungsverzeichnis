require 'elasticsearch'
require 'typhoeus/adapters/faraday'

module KITBox
  class Application < Rails::Application
    # YAML.load_file("#{File.join(Rails.root, '/config/environments/', Rails.env, 'elasticsearch.yml')}").each { |k,v| config.send "#{k}=", v }
    # elasticsearch_client = Elasticsearch::Client.new({
    #   url: "http://#{ENV['ELASTICSEARCH_USER']}:#{ENV['ELASTICSEARCH_KEY']}@#{ENV['ELASTICSEARCH_HOST']}",
    #   log: true,
    #   transport_options: { request: { timeout: 2*60 } }
    # })
    # config.send 'elasticsearch_client=', elasticsearch_client
  end
end

# Rails.application.config.elasticsearch[:indices].each do |es_index|
#   es_index_name = es_index[0]
#   es_maps = es_index[1]['mappings']
#   es_maps.each do |es_type, es_body|
#     Rails.application.config.elasticsearch_client.indices.put_mapping index: es_index_name, type: es_type, body: es_body
#   end
# end
