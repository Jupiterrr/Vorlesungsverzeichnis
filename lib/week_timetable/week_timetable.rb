require 'active_support/all'

class WeekTimetable
  attr_reader :dates

  def initialize(event_dates=[])
    dates = dedupe(event_dates)
    mapped_dates = map_dates_to_week(dates)
    @dates = mapped_dates
  end

  def map_dates_to_week(event_dates)
    mapper = WeekMapper.new(event_dates)
    mapper.event_dates
  end

  def dedupe(event_dates)
    groups = event_dates.group_by do |date|
      [date.start_time.wday, [date.start_time.hour, date.start_time.min], [date.end_time.hour, date.end_time.min], date.room_name]
    end
    dates = groups.map {|k,v| v.first }
  end


  class WDay
    attr_reader :name, :dates, :wday

    DAY_NAMES = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)

    def initialize(wday, dates)
      @wday = wday
      @name = DAY_NAMES.fetch(wday)
      @dates = dates
    end

  end

  class Week

    def initialize(dates)
      wday_groups = dates.group_by {|date| date.start_time.wday }

      @week = (0..6).inject({}) do |week, wday|
        dates = wday_groups.fetch(wday, [])
        week[wday] = WDay.new(wday, dates)
        week
      end
    end

    def [](wday)
      @week.fetch(wday)
    end

    def each
      (1..5).each do |wday|
        yield @week[wday]
      end
      yield @week[6]
      #yield @week[0]
    end

  end

  def week
    week = Week.new(@dates)
  end

end

require_relative "date_reducer"
require_relative "week_mapper"
