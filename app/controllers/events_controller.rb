require_dependency "event_unsubscriber"
class EventsController < ApplicationController

  before_filter :authorize, except: [:show, :info, :dates]

  def show
    @date_groups = EventDateGrouper.group(event.dates.includes({room: :poi}))
    respond_to do |format|
      format.html {
        @board = event.board
        @posts = @board.posts.limit(20).includes(:author, {comments: :author})
      }
      format.json do
        data = event.as_json(current_user)
        data[:authenticated] = !!current_user
        data[:html] = render_to_string(partial: "vvz/event_col.html", layout: false, locals: {event: event, date_groups: @date_groups})
        render json: data
      end
    end
  end

  # def dates; end

  # def info; end

  def subscribe
    trigger_ical_update
    event.subscribe(current_user)
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Erfolgreich angemeldet' }
      format.json { render json: { message: "Erfolgreich angemeldet" }  }
    end
  rescue ActionController::RedirectBackError
    redirect_to event_path(event)
  end

  def unsubscribe
    trigger_ical_update
    event.unsubscribe(current_user)
    respond_to do |format|
      format.html { redirect_to :back, notice: "Erfolgreich entfernt" }
      format.json { render json: { message: "Erfolgreich entfernt" }  }
    end
  rescue ActionController::RedirectBackError
    redirect_to event_path(event)
  end

  def unsubscribe_all
    trigger_ical_update
    EventUnsubscriber.unsubscribe_all(current_user)
    respond_to do |format|
      format.html { redirect_to :back, notice: "Erfolgreich entfernt" }
      format.json { render json: { message: "Erfolgreich entfernt" }  }
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  # def edit_user_text; end

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

  def trigger_ical_update
    IcalUpdateWorker.perform_async(current_user.id) if feature(:background_ical_generation)
  end

end
