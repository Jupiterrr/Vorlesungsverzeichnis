module DashboardHelper

  def upcomming_date(date)
    str = day(date.start_time)
    str += date.start_time.strftime("%H:%M")
    str += " - "
    str += date.end_time.strftime("%H:%M")
    str
  end

  def shorten_room_name(name)
    if match = name.match(/(?:\d+.\d+\s)(.*)/)
      match.captures.first
    end
  end

  def room_link_by_date(date)
    if (room = date.room) && room.poi
      link_to shorten_room_name(date.room_name), map_path(room.poi)
    else
      date.room_name
    end
  end

  private

  def day(date)
    case
    when date.today? then ""
    when (date - 1.day).today? then "morgen, "
    else "Montag, "
    end
  end

end



