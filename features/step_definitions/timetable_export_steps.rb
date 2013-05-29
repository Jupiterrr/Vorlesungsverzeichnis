Then /^I see my ical url within ".ical_url"$/ do
  url = "/timetable/#{@current_user.timetable_id}.ics"
  find(".ical_url input").value.should have_content url 
end

Given /^a User attending "Schweidsch 1"$/ do
  @user = User.create
  @user.events.create name: "Schweidsch 1"
end

When /^I go to ical url of that user$/ do
  visit timetable_path(@user.timetable_id)
end

Then /^I see an ical file$/ do
  page.should have_content "BEGIN:VCALENDAR"
end

Then /^I should see a new url$/ do
  pending # express the regexp above with the code you wish you had
end
