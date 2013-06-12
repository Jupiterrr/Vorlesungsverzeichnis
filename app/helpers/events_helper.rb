# encoding: UTF-8
module EventsHelper

  def url_to_ical(url)
    url = url.split("://").last
    "webcal://#{url}.ics"
  end

  def event_pos(date, time)
    start_time, end_time = time.split("-")

    day = Date.parse(date).wday
    day = 0 if day >= 7

    sh, sm =  start_time.split(":");
    sh = sh.to_i - 7 #start at 7:00
    sm = sm.to_i / 15 #viertelstundentakt
    start = sh*4 + sm

    eh, em =  end_time.split(":");
    eh = eh.to_i - 7
    em = em.to_i / 15
    duration = (eh-sh)*4 + (em-sm)
    #binding.pry
    "d#{day} s#{start} l#{duration}"
  end

  def to_german_day(date)
    days = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag)
    i = Date.parse(date).wday
    days[i] + "s"
  end

  def pretty_event_date(date)
    days = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag)
    s = date.start_time_local
    e = date.end_time_local
    if s.to_date == s.to_date
      day = days[s.wday]
      "#{day}, #{s.strftime("%d.%m.%Y <span class=\"seperator\" /> %H:%M")} - #{e.strftime("%H:%M")}".html_safe
    else
      "#{s.strftime("%d.%m.%Y %H:%M")} - #{e.strftime("%d.%m.%Y %H:%M")}"
    end
  end

  def next_date(event, date)
    time = date.start_time
    text = ""
    text << "<em>" << date_to_human(time) << " "
    text << time.strftime("%H:%M Uhr") << "</em> "
    text << "in <em>" << @next.room << "</em>"
    text.html_safe
  end

  def date_to_human(date)
    if date < 7.days.from_now
      german_day(date)
    else
      date.strftime("%d.%m.")
    end
  end

  def german_day(date)
    days = %w(Montag Dienstag Mittwoch Donnerstag Freitag Samstag Sonntag)
    days[date.wday]
  end

end
