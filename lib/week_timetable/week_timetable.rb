require 'active_support/all'

class WeekTimetable
  attr_reader :dates

  def initialize(event_dates=[])
    #binding.pry
    reduced_dates = reduce_dates(event_dates)
    week_dates = map_dates_to_week(reduced_dates)
    @dates = week_dates
  end

  def reduce_dates(event_dates)
    reducer = DatesReducer.new(event_dates)
    reducer.event_dates
  end

  def map_dates_to_week(event_dates)
    mapper = WeekMapper.new(event_dates)
    mapper.event_dates
  end

end

require_relative "date_reducer"
require_relative "week_mapper"