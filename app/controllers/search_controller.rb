# encoding: UTF-8
class SearchController < ApplicationController

  def index
    @type = params.fetch(:type, "vvz") 
    @page = params.fetch(:p, 0)
    q = params.fetch(:q, "")
    
    @term_id = params.fetch(:term, Vvz.current_term.id)
    @term = Vvz.find(@term_id)

    @vvz_results = @term.descendants.vvz_search(q) if @page == 0
    @event_results = Event.where(term: @term.name).vvz_search(q)    
    
    respond_to do |format|
      format.html {
        @event_results = @event_results.page(@page).per(10)
      }
      format.json { 
        render json: autocomplete(q, @vvz_results, @event_results)
      }
    end
  end

  private 

  def autocomplete(q, vvzs, events)
    Rails.cache.fetch(["search:autocomplete", q], expires_in: 1.day) do
      results = vvzs.limit(10) + events.limit(10)
      js_result(results)
    end 
  end

  def js_result(results) 
    results.map do |node|
      if node.is_a?(Event)
        vvz = node.vvzs.first
        {
          value: node.name,
          description: node.simple_type,
          key: event_vvz_url(vvz, node)
        }
      else
        {
          value: node.name,
          key:  vvz_url(node)
        }
      end
    end
  end


end
