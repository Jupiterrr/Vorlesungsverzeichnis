class IcalService

  def self.ical(events)
    ical = RiCal.Calendar do |cal|
      cal.add_x_property 'X-WR-CALNAME', "KitHub.de"
      events.each do |event|
        event.dates.each do |date|
          cal.event do |e|
            event_url = Rails.application.routes.url_helpers.event_url(event, host: "www.kithub.de")
            e.summary     = event.name
            e.dtstart     = date.start_time
            e.dtend       = date.end_time
            e.location    = date.room_name || ""
            e.description = event_url
            e.url         = event_url
            e.uid         = "#{date.id}@kit.edu"
            e.dtstamp     = date.created_at || Time.now
          end
        end
      end
    end
    # rical puts symbols instead of strings in the file
    # so we remove the prepending colon
    output = ical.to_s.gsub("X-WR-CALNAME::", "X-WR-CALNAME:")

    output = output.gsub("\n", "\r\n")
    output = output.gsub("VERSION:2.0\r\n", "")
    output = output.sub("\r\n", "\r\nVERSION:2.0\r\n")
    output
  end

end
