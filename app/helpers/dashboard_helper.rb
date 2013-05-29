module DashboardHelper

  def upcomming_date(date)
    str = day(date.start_time)
    str += date.start_time.strftime("%H:%M")
    str += " - "
    str += date.end_time.strftime("%H:%M") 
    str
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


              