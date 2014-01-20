class EventsController < ApplicationController

  before_filter :authorize, except: [:show, :info, :dates]

  def show
    @date_groups = EventDateGrouper.group(event.dates)
    respond_to do |format|
      format.html {
        render action: :info #unless authorized?
      }
      format.json do
        data = event.as_json(current_user)
        data[:authenticated] = !!current_user
        data[:html] = render_to_string(partial: "vvz/event_col", layout: false, locals: {event: event})
        render json: data
      end
    end
  end

  def dates
  end

  def info
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

  def edit_user_text
  end

  def update_user_text
    if event.update_attributes params[:event].slice(:user_text_md)
      redirect_to event
    else
      redirect_to action: edit_user_text
    end
  end

  def preview_md
    render text: view_context.markdown(params[:text].to_s, false)
  end

  private

  def event
    @event ||= Event.find(params[:id])
  end
  helper_method :event

end
