require_dependency "column_view"
class VvzController < ApplicationController

  caches_action :preload, :cache_path => Proc.new { |c| c.request.url }
  caches_action :index, :unless => proc { authorized? } #, :layout => false
  caches_action :show, :unless => proc { authorized? } #, :layout => false
  caches_action :events, :unless => proc { authorized? }

  def index
    expire_page :action => :preload, :format => :js if params[:expire]
    @id = vvz.preload_id
    @path = vvz.vvz_path
    @term = vvz.term or raise ActionController::RoutingError.new('Term not found!')
    @terms = Vvz.terms

    if vvz.is_leaf
      events = vvz.events
      event_map = events.map {|e| [e.id, [e.name, e._type]]}.to_h
      @events_json = event_map.to_json.html_safe
    end

    @column_view = ColumnView.new(vvz, event)
  end

  def show
    index
    render :action => :index
  end

  def events
    index
    render :action => :index
  end

  def preload
    events = Vvz.find(params[:id]).events
    event_map = events.map do |e|
      {
        id: e.id,
        name: e.name,
        eventType: e.simple_type
      }
    end
    render text: event_map.to_json
  end

  private

  def vvz
    @vvz ||= Vvz.find_or_current_term(params[:id])
  end
  helper_method :vvz

  def event
    @event ||= Event.find(params[:event_id]) if params[:event_id]
  end
  helper_method :event

end
