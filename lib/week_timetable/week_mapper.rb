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
    def map_date_to_week(datetime, week=Time.now)
      date = datetime.to_date
      week_date = Date.today.beginning_of_week(:sunday) + date.wday
      week_datetime = datetime.advance(days: (week_date-date))
    end

  end
end
