class TimetableController < ApplicationController

  before_filter :authorize, only: [:index, :regenerate]

  def index
    timetable = Timetable.by_user(current_user)
    @timetable = timetable.as_json
  end

  def regenerate
    current_user.generate_timetable_id
    current_user.save
    redirect_to action: "index"
  end

  def ical
    text = Timetable.to_ical(params[:timetable_id]).to_s
    text = text.gsub("\n", "\r\n")
    text = text.gsub("VERSION:2.0\r\n", "")
    text = text.sub("\r\n", "\r\nVERSION:2.0\r\n")
    render text: text, content_type: Mime::ICS
  end

  def exam
    @dates = EventDate.by_user(current_user).where(type: "exam").order(:start_time)
  end

end
