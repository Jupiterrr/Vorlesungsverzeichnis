require 'typhoeus/adapters/faraday'

class VvzTypeaheadSearch

  def initialize(params)
    page = params.fetch(:p, 0)
    @query = params.fetch(:q, "").strip

    term_id = params.fetch(:term, Vvz.current_term.id)
    @term = Vvz.find(term_id)
  end

  def autocomplete()
    autocomplete_search_cached(@query, @term)
  end

  def autocomplete_search_cached(query, term)
    cache_key = ["search:autocomplete", query, term.id]
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      autocomplete_search(query, term)
    end
  end

  def autocomplete_search(query, term)
    search_result = ElasticKithubSearch.new().search_all(query, term: term, size: 10)
    results = js_result(search_result.results)
  end

  def js_result(results)
    results.map do |item|
      result = {
        value: item["_source"]["name"],
        key: item["_source"]["url"]
      }
      if item["_type"] == "event"
        result[:description] = item["_source"]["event_type"]
      end
      result
    end
  end

end
