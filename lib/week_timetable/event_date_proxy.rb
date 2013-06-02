class WeekTimetable::WeekMapper

  # ensures that original dates don't change
  class EventDateProxy
    attr_accessor :start_time, :end_time

    def initialize(event_date)
      @target = event_date
      @start_time = event_date.start_time
      @end_time = event_date.end_time
    end

    def method_missing(method, *args, &block)
      @target.send(method, *args, &block)
    end

  end

end