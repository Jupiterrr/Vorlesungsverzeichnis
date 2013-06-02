class WeekTimetable

  # Aims to reduce event_dates so that
  # every recuring event_date appears only once.
  # Only event_dates that happen on the same day
  # at the same time will be reduced.
  class DatesReducer
    attr_reader :event_dates

    def initialize(event_dates=[])
      @event_dates = []
      @event_dates_hashes = []
      event_dates.each {|event_date| push(event_date)}
    end

    def push(event_date)
      unless exists?(event_date)
        @event_dates << event_date
        @event_dates_hashes << get_hash(event_date)
      end
    end

    def exists?(event_date)
      hash = get_hash(event_date)
      @event_dates_hashes.include?(hash)
    end

    # Produces a hash_key that is uniq for every
    # event_date that hash different times or
    # different events
    def get_hash(edate)
      a = []
      a << get_time_hash(edate.start_time)
      a << get_time_hash(edate.end_time)
      a << edate.event_id
      a.join("#")
    end

    def get_time_hash(time)
      [time.seconds_since_midnight, time.wday]
    end

    alias :<< :push
  end
end