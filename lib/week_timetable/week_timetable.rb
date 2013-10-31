require 'active_support/all'

class WeekTimetable
  attr_reader :dates

  def initialize(event_dates=[])
    groups = EventDateGrouper.group(event_dates)
    raw_dates = groups.map {|g| g.event_dates.first }
    week_dates = map_dates_to_week(raw_dates)
    @dates = week_dates
  end

  def map_dates_to_week(event_dates)
    mapper = WeekMapper.new(event_dates)
    mapper.event_dates
  end

  ReapetingEvent = Struct.new(:wday, :start_time, :end_time, :room)
  TimeWithoutDate = Struct.new(:wday, :start_time, :end_time, :room)

end

require_dependency "week_timetable/date_reducer"
require_dependency "week_timetable/week_mapper"
