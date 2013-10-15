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

  class DateFormater

    DAYS = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)

    def initialize(date)
      @date = date
    end

    def day
      DAYS[@date.start_time.wday]
    end

    def day_short
      day[0..1]
    end

    def format_time(time)
      time.strftime("%H:%M")
    end

    def time
      format_time(@date.start_time) << " - " << format_time(@date.end_time)
    end

    def time_short
      format_time(@date.start_time) << "-" << format_time(@date.end_time)
    end

    def date
      @date.start_time.strftime("%d.%m.%Y")
    end

    def room
      @date.room_name
    end

  end

  def date_formater(date)
    DateFormater.new(date)
  end
  # def pretty_event_date(date)


  #   start_time_s = s.strftime("%H:%M")
  #   end_time_s = e.strftime("%H:%M")
  #   room_s =
  #   "<span class=\"fr\">#{date_s}</span> #{day}, #{start_time_s} - #{end_time_s} <br/>#{room_s}".html_safe
  # end

  def next_date(event, date)
    time = date.start_time
    text = ""
    text << "<em>" << date_to_human(time) << " "
    text << time.strftime("%H:%M Uhr") << "</em> "
    text << "in <em>" << @next.room_name << "</em>"
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
