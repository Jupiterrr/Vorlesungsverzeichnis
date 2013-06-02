require_relative "event_date_proxy"

class WeekTimetable

  # Maps dates to a given Week
  class WeekMapper
    attr_reader :event_dates

    def initialize(event_dates=[], week=Time.now)
      @event_dates = map_dates_to_week(event_dates, week)
    end

    def map_dates_to_week(event_dates, week=Time.now)
      event_dates.map do |event_date|
        ed_proxy = EventDateProxy.new(event_date)
        ed_proxy.start_time = map_date_to_week(event_date.start_time, week)
        ed_proxy.end_time = map_date_to_week(event_date.end_time, week)
        ed_proxy
      end
    end

    # maps the weekday index to a date in the current week
    def map_date_to_week(date, week=Time.now)
      date = date.to_datetime
      last_sunday = week.beginning_of_week - 1.day
      new_date = last_sunday.advance({
        days: date.wday,
        hours: date.hour,
        minutes: date.minute,
        seconds: date.second
      })
      new_date = new_date.change(offset: date.zone)
      new_date
    end

  end
end