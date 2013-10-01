require 'active_support/all'

class WeekTimetable
  attr_reader :dates

  def initialize(event_dates=[])
    groups = event_dates.group_by do |date|
      [date.start_time.wday, [date.start_time.hour, date.start_time.min], [date.end_time.hour, date.end_time.min], date.room_name]
    end
    raw_dates = groups.map {|k,v| v.first }
    week_dates = map_dates_to_week(raw_dates)
    @dates = week_dates
  end

  def map_dates_to_week(event_dates)
    mapper = WeekMapper.new(event_dates)
    mapper.event_dates
  end

end

require_relative "date_reducer"
require_relative "week_mapper"
