# encoding: UTF-8
require_dependency "search/elastic_kithub_search"
require_dependency "search/vvz_typeahead_search"

class SearchController < ApplicationController

  def index
    respond_to do |format|
      format.html {
        @terms = Vvz.terms
        term_id = params.fetch(:term, Vvz.current_term.id)
        term = Vvz.find(term_id)
        @search_result = ElasticKithubSearch.new().search_all(params[:q], term: term, page: params.fetch("p", 1).to_i)
        @paginatable_array = Kaminari.paginate_array([], total_count: @search_result.total).page(@search_result.page).per(@search_result.size)
      }
      format.json {
        render json: VvzTypeaheadSearch.new(params).autocomplete
      }
    end
  end

end
