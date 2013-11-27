# encoding: UTF-8
class SearchController < ApplicationController

  def index
    @type = params.fetch(:type, "vvz")
    @page = params.fetch(:p, 0)
    q = params.fetch(:q, "")

    @terms = Vvz.terms
    @term_id = params.fetch(:term, Vvz.current_term.id)
    @term = Vvz.find(@term_id)

    @vvz_results = @term.descendants.vvz_search(q).limit(15) if @page == 0
    event_search = Event.vvz_search(q).where(term: @term.name).not_orphans

    respond_to do |format|
      format.html {
        @event_results = event_search.page(@page).per(10)
      }
      format.json {
        render json: autocomplete(q, @term_id, @vvz_results, event_search)
      }
    end
  end

  private

  def autocomplete(q, term_id, vvzs, events)
    Rails.cache.fetch(["search:autocomplete", q, term_id], expires_in: 1.day) do
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
