require_dependency "react_renderer"

class TimetableController < ApplicationController

  before_filter :authorize, only: [:index, :regenerate, :new_timetable]

  def index
    timetable = Timetable.by_user(current_user)
    @timetable = timetable.as_json
  end

  def new_timetable
    timetable = Timetable.by_user(current_user)
    @timetable_html = ReactRenderer.timetable(timetable.as_json)
  end

  def regenerate
    current_user.generate_timetable_id
    current_user.save
    redirect_to action: "index"
  end

  def ical
    ::NewRelic::Agent.add_custom_attributes({
      timetable_id: params[:timetable_id]
    })

    text = Timetable.to_ical(params[:timetable_id])
    # response.headers['Content-Type'] = "text/calendar; charset=UTF-8"
    # response.headers['Cache-Control'] = "no-cache, must-revalidate"
    render text: text, content_type: Mime::ICS #"text/calendar" #
  end

  def exam
    @dates = EventDate.by_user(current_user).where(type: "exam").order(:start_time)
  end

  def print
    timetable_url = print_service_timetable_index_url(user_id: current_user.id, no_color: params[:no_color])
    url64 = Base64.encode64(timetable_url)
    color_code = no_color? ? "b/w" : "color"
    ::NewRelic::Agent.add_custom_attributes(print_type: color_code)
    redirect_to "http://service.kithub.de/print/?url=#{url64}"
    # redirect_to "http://localhost:3000/?url=#{url64}"
  end

  def print_service
    user = User.find(params[:user_id])
    timetable = Timetable.by_user(user)
    @timetable = timetable.as_json
    render layout: false
  end

  private

  def no_color?
    params["no_color"]=="1"
  end
  helper_method :no_color?

end
