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
    when 'the event page'
      "/events/#{@event.id}"
    when "vvz", 'the vvz page'
      vvz_index_path
    when "the vvz page of the event", "the vvz event page"
      vvz = @event.vvzs.first
      "/vvz/#{vvz.id}/events/#{@event.id}"
    when 'the "Schwedisch 1" vvz page'
      event = Event.find_by_name "Schwedisch 1"
      vvz = event.vvzs.first
      "/vvz/#{vvz.id}/events/#{event.id}"
    when /the semester page/
      semester_index_path
    when 'the timetable page'
      timetable_index_path
    when 'the signup page'
      signup_path
    when 'the dashboard page'
      dashboard_index_path
    when 'my exam dates page'
      discipline_exam_dates_path(@current_user.disciplines.first)
    when 'the page of the exam date'
      discipline_exam_date_path(@exam_date.discipline, @exam_date)
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
      "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)
