require './lib/week_timetable/week_timetable'

class Timetable
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
        "start" => js_time(date.start_time_local),
        "end" => js_time(date.end_time_local),
        "title" => date.event.name,
        "url" => event_url(date.event)
      }
    end
  end

  def event_url(event)
    "events/#{event.id}"
  end

  def js_time(time)
    time.to_i*1000
  end

  def self.to_ical(timetable_id)
    user = User.find_by_timetable_id timetable_id
    raise ActiveRecord::RecordNotFound if user.nil?
    events = user.events
    RiCal.Calendar do |cal|
      events.each do |event|
        event.dates.each do |date|
          cal.event do |e|
            e.summary     = event.name
            #event.description = "First US Manned Spaceflight\n(NASA Code: Mercury 13/Friendship 7)"
            e.dtstart     = date.start_time
            e.dtend       = date.end_time
            e.location    = date.room || ""
            e.url         = event.url
            #e.uid         = "#{event.id}@kit.edu"
          end
        end
      end
    end
  end

end