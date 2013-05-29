module NavigationHelpers
  def path_to(page_name)
    puts "page: #{page_name}"
    case page_name
    when /the "Schwedisch 1" vvz_event page/
      event = Event.find_by_name "Schwedisch 1"
      vvz = event.vvzs.first
      "/vvz/#{vvz.id}/events/#{event.id}"
    when /the "(.*?)" event page/
      event = Event.find_by_name $1
      event_path event
    when 'the "Schwedisch 1" event page'
      event = Event.find_by_name "Schwedisch 1"
      vvz = event.vvzs.first
      "/events/#{event.id}"
    when "vvz", 'the vvz page'
      vvz_index_path
    when 'the "Schwedisch 1" vvz page'
      event = Event.find_by_name "Schwedisch 1"
      vvz = event.vvzs.first
      vvz_event_path(vvz, event)
    when /the semester page/
      semester_index_path
    when 'the timetable page'
      timetable_semester_index_path
    when 'the signup page'
      signup_path
    when 'the dasboard page'
      dashboard_index_path
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
      "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)