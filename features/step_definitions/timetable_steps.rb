Given /^an "Schwedisch 1" event$/ do
  vvz = Vvz.create name: "node"
  @event = vvz.events.create name: "Schwedisch 1"
end

Given /^the event has following dates:$/ do |table|
  table.hashes.each do |hash|
    date = Time.now.strftime("%m.%d.%Y")
    start = Time.parse("#{date} #{hash[:"start"]} UTC")
    _end = Time.parse("#{date} #{hash[:"end"]} UTC")
    @event.dates.create start_time: start, end_time: _end
  end
end

Given /^I attend "Schwedisch 1"$/ do
  @current_user.events << @event
end

Given /^the current date is "(.*?)"$/ do |date|
  Timecop.travel(Time.parse(date))
end

When /^I click on "Schwedisch 1" within "#calendar"$/ do
  with_scope("#calendar") do
    find('.wc-cal-event:contains("Schwedisch 1")').click #trigger('click')
    #binding.pry
  end
  sleep 2
end

Given /^an event named "(.*?)"$/ do |event_name|
  vvz = Vvz.current_term.leafs.first
  @event = vvz.events.create name: event_name, _type: "Seminar (S), Seminar (S)"
end