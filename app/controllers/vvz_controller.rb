require_dependency "column_view"
class VvzController < ApplicationController

  caches_action :preload, :cache_path => Proc.new { |c| c.request.url }
  caches_action :index, :unless => proc { authorized? } #, :layout => false
  caches_action :show, :unless => proc { authorized? } #, :layout => false
  caches_action :events, :unless => proc { authorized? }

  def index
    expire_page :action => :preload, :format => :js if params[:expire]
    @vvz = Vvz.find_or_current_term(params[:id])
    @id = @vvz.preload_id
    @event = Event.find_by_id(params[:event_id])

    @path = @vvz.vvz_path
    @term = @vvz.term or raise "Term not found!"
    @terms = Vvz.terms

    if @vvz.is_leaf
      events = @vvz.events
      event_map = events.map {|e| [e.id, [e.name, e._type]]}.to_h
      @events_json = event_map.to_json.html_safe
    end

    @column_view = ColumnView.new(@vvz, @event)
  end

  def show
    index
    render :action => :index
  end

  def events
    @event = Event.find(params[:event_id])
    days = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)
    @date_groups = EventDateGrouper.group(@event.dates)
    index
    render :action => :index
  end

  def preload
    events = Event.where(id: params[:ids].split(","))
    event_map = events.map {|e| [e.id, [e.name, e._type]]}.to_h
    render text: event_map.to_json
    # @term = Vvz.find(params[:id])
    # @term.term? or raise "#{@term} is not a term"
    # @tree = @term.subtree.includes(:events).arrange
  end

end
