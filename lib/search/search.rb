# require_relative "elastic_kithub_search"

# class Search

#   def initialize(params)
#     @page = params.fetch(:p, 0)
#     @query = params.fetch(:q, "").strip

#     term_id = params.fetch(:term, Vvz.current_term.id)
#     @term = Vvz.find(term_id)
#   end


#   SearchResult = Struct.new(:query, :term, :vvzs, :events, :event_no_match)

#   def search()
#     vvz_results = search_vvz(@query, @term, @page)
#     event_results = search_event_paged(@query, @term, @page)
#     event_no_match = search_event_no(@query, @term, @page)
#     SearchResult.new(@query, @term, vvz_results, event_results, event_no_match)
#   end

#   # core


#   def search_vvz(query, term, page=0)
#     if page == 0
#       term.descendants.vvz_search(query).limit(15)
#     else
#       Vvz.where("1 = 0") # empty
#     end
#   end

#   def search_event(query, term)
#     Event.vvz_search(query).where(term: term.name).not_orphans.uniq
#   end

#   def search_event_paged(query, term, page)
#     search_event(query, term).page(page).per(10)
#   end

#   def search_event_no(query, term, page=0)
#     if page == 0
#       Event.where(term: term.name).not_orphans.find_by_no(query).first
#     end
#   end


# end
