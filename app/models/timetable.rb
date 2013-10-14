require './lib/week_timetable/week_timetable'

class Timetable
  include Rails.application.routes.url_helpers

  attr_reader :week

  def initialize(events=[])
    dates = events.map(&:dates).flatten
    @week_dates = WeekTimetable.new(dates).dates
  end

  def self.by_user(user)
    Timetable.new(user.events)
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
    time.to_i*1000
  end

  def self.to_ical(timetable_id)
    user = User.find_by_timetable_id timetable_id
    raise ActiveRecord::RecordNotFound if user.nil?
    events = user.events
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
          end
        end
      end
    end
    # rical puts symbols instead of strings in the file
    # so we remove the prepending colon
    output = ical.to_s.gsub("X-WR-CALNAME::", "X-WR-CALNAME:")
  end

end
