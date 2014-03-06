class Search

  def initialize(params)
    @page = params.fetch(:p, 0)
    @query = params.fetch(:q, "")

    term_id = params.fetch(:term, Vvz.current_term.id)
    @term = Vvz.find(term_id)
  end


  SearchResult = Struct.new(:query, :term, :vvzs, :events)

  def search()
    vvz_results = search_vvz(@query, @term, @page)
    event_results = search_event_paged(@query, @term, @page)
    SearchResult.new(@query, @term, vvz_results, event_results)
  end


  def autocomplete()
    autocomplete_search_cached(@query, @term)
  end



  # core


  def search_vvz(query, term, page=0)
    if page == 0
      term.descendants.vvz_search(query).limit(15)
    else
      Vvz.where("1 = 0") # empty
    end
  end

  def search_event(query, term)
    Event.vvz_search(query).where(term: term.name).not_orphans
  end

  def search_event_paged(query, term, page)
    search_event(query, term).page(page).per(10)
  end

  def autocomplete_search(query, term)
    vvz_results = search_vvz(query, term).limit(10)
    event_results = search_event(query, term).limit(10)
    results = vvz_results + event_results
    js_result(results)
  end

  def autocomplete_search_cached(query, term)
    cache_key = ["search:autocomplete", query, term.id]
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      autocomplete_search(query, term)
    end
  end

  def js_result(results)
    results.map do |node|
      if node.is_a?(Event)
        vvz = node.vvzs.first
        {
          value: node.name,
          description: node.simple_type,
          key: "/vvz/#{vvz.id}/events/#{node.id}"
        }
      else
        {
          value: node.name,
          key:  "/vvz/#{node.id}"
        }
      end
    end
  end

end
