require 'elasticsearch'
require_relative 'sanitize_string'

class ElasticKithubSearch

  def initialize(client=Rails.application.config.elasticsearch_client)
    @client = client
  end

  def search_all(query, options={})
    size = options.fetch(:size, 10)
    page = options.fetch(:page, 1)
    from = size*(page-1)
    term = options.fetch(:term)

    raw_request = IO.read(File.expand_path("../vvz_search.json", __FILE__))
    raw_request.gsub!("%size", size.to_s)
    raw_request.gsub!("%from", from.to_s)
    raw_request.gsub!("%term", term.name)
    raw_request.gsub!("%query", escape(query))

    result = @client.search(index: 'kithub', body: raw_request)["hits"]
    SearchResponse.new(query: query, results: result["hits"], total: result["total"], from: from, size: size, term: term)
  end

  def escape(query)
    ElasticSearchHelpers.sanitize_string(query)
  end

  #ap @client.explain(index: 'kithub', type: 'event', id: '3514', body: QUERY.gsub("%q", q))

  class SearchResponse

    attr_reader :results, :query, :type, :term, :total, :size

    def initialize(hash)
      @results = hash.fetch(:results)
      @total = hash.fetch(:total)
      @from = hash.fetch(:from)
      @size = hash.fetch(:size)
      @query = hash.fetch(:query)
      @term = hash.fetch(:term)
    end

    def page
      @from/@size+1
    end

  end
end
