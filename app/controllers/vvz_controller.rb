class VvzController < ApplicationController

  caches_page :preload
  caches_action :index, :unless => proc { authorized? } #, :layout => false
  caches_action :show, :unless => proc { authorized? } #, :layout => false
  caches_action :events, :unless => proc { authorized? }

  def index
    expire_page :action => :preload, :format => :js if params[:expire]
    @vvz = Vvz.find_or_current_term(params[:id])
    @id = @vvz.preload_id

    @path = @vvz.vvz_path
    @term = @vvz.term or raise "Term not found!"
    @terms = Vvz.terms

    @spalten = @vvz.collums(@event)
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
    @term = Vvz.find(params[:id])
    @term.term? or raise "#{@term} is not a term"
    @tree = @term.subtree.includes(:events).arrange
  end

end
