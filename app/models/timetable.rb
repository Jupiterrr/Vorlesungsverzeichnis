require_dependency "week_timetable/week_timetable"
require_dependency "event_date_grouper"

class Timetable
  include Rails.application.routes.url_helpers

  attr_reader :week

  def initialize(events=[])
    dates = events.map(&:dates).flatten
    @week_dates = WeekTimetable.new(dates).dates
  end

  def self.by_user(user)
    events = user.events.includes(:event_dates => :room)
    Timetable.new(events)
  end

  def as_json
    @week_dates.map do |date|
      {
        "id" => date.event.id,
        "start" => js_time(date.start_time),
        "end" => js_time(date.end_time),
        "title" => "#{date.event.name} <br>#{date.room_name}",
        "url" => event_path(date.event)
      }
    end
  end

  def js_time(time)
    time.to_a[0..5].reverse # eg [2014, 3, 31, 11, 30, 0]
  end

  def self.to_ical(timetable_id)
    user = User.find_by_timetable_id timetable_id
    raise ActiveRecord::RecordNotFound if user.nil?
    events = user.events.includes(:event_dates => :room)
    ical = RiCal.Calendar do |cal|
      cal.add_x_property 'X-WR-CALNAME', "KitHub.de"
      events.each do |event|
        event.dates.each do |date|
          cal.event do |e|
            event_url = Rails.application.routes.url_helpers.event_url(event, host: "www.kithub.de")
            e.summary     = event.name
            e.dtstart     = date.start_time
            e.dtend       = date.end_time
            e.location    = date.room_name || ""
            e.description = event_url
            e.url         = event_url
            e.uid         = "#{date.id}@kit.edu"
            e.dtstamp     = date.created_at || Time.now
          end
        end
      end
    end
    # rical puts symbols instead of strings in the file
    # so we remove the prepending colon
    output = ical.to_s.gsub("X-WR-CALNAME::", "X-WR-CALNAME:")

    output = output.gsub("\n", "\r\n")
    output = output.gsub("VERSION:2.0\r\n", "")
    output = output.sub("\r\n", "\r\nVERSION:2.0\r\n")
    output
  end

end
