# encoding: UTF-8
require_dependency "search/search"
class SearchController < ApplicationController

  def index
    search = Search.new(params)
    respond_to do |format|
      format.html {
        @terms = Vvz.terms
        @search_result = search.search()
      }
      format.json {
        render json: search.autocomplete()
      }
    end
  end

end
