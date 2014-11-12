class EventDateGrouper

  EventDateGroup = Struct.new(:wday, :start_time, :end_time, :room_name, :event_dates, :key)

  def self.group(event_dates)
    raw_groups = event_dates.group_by {|date| self.group_key(date) }
    groups = raw_groups.map do |(wday, start_time, end_time, room_name), dates|
      key = self.group_key(dates.first)
      EventDateGroup.new(wday, start_time, end_time, room_name, dates, key)
    end
    groups = self.sort_by_wday(groups)
  end

  def self.group_key(date)
    [date.start_time.wday, [date.start_time.hour, date.start_time.min], [date.end_time.hour, date.end_time.min], date.room_name]
  end

  def self.sort_by_wday(groups)
    groups.sort_by {|g| (g.wday-1) % 7 }
  end

end
