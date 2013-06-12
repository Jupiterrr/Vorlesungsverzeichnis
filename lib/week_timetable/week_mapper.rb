class WeekTimetable

  # Maps dates to a given Week
  class WeekMapper
    attr_reader :event_dates

    def initialize(event_dates=[], week=Time.now)
      @event_dates = map_dates_to_week(event_dates, week)
    end

    def map_dates_to_week(event_dates, week=Time.now)
      event_dates.map do |event_date|
        event_date.readonly! # prevent changes on the object in the db
        event_date.start_time = map_date_to_week(event_date.start_time, week)
        event_date.end_time = map_date_to_week(event_date.end_time, week)
        event_date
      end
    end

    # maps the weekday index to a date in the current week
    def map_date_to_week(date, week=Time.now)
      date = date.to_datetime.utc
      s = week.utc.beginning_of_week(:sunday) # last sunday
      new_date = DateTime.new(s.year, s.month, s.day, date.hour, date.minute, date.second)
      new_date = new_date.advance(days: date.wday)
      new_date
    end

  end
end