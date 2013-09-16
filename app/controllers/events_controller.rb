class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html {
        authorize
        @event = Event.find(params[:id])
      }
      format.json do
        data = @event.as_json(current_user)
        data[:authenticated] = !!current_user
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
