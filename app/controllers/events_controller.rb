class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
    days = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag)
    @date_groups = @event.dates.group_by do |date|
      day = days[date.start_time.wday][0..1]
      [day, [date.start_time.hour, date.start_time.min], [date.end_time.hour, date.end_time.min], date.room]
    end
    respond_to do |format|
      format.html {
        authorize
        @event = Event.find(params[:id])
      }
      format.json do
        data = @event.as_json(current_user)
        data[:authenticated] = !!current_user
        data[:html] = render_to_string(partial: "vvz/event_col", layout: false, locals: {event: @event})
        render json: data
      end
    end
  end

  def dates
    @event = Event.find(params[:id])
  end

  def subscribe
    event = Event.find(params[:id])
    event.subscribe current_user
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Erfolgreich angemeldet' }
      format.json { render json: { message: "Erfolgreich angemeldet" }  }
    end
  end

  def unsubscribe
    event = Event.find(params[:id])
    current_user.events.delete event
    respond_to do |format|
      format.html { redirect_to :back, notice: "Erfolgreich entfernt" }
      format.json { render json: { message: "Erfolgreich entfernt" }  }
    end
  end

  def unsubscribe_all
    current_user.events.clear
    respond_to do |format|
      format.html { redirect_to :back, notice: "Erfolgreich entfernt" }
      format.json { render json: { message: "Erfolgreich entfernt" }  }
    end
  end

end
