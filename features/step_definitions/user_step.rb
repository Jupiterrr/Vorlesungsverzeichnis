
Then /^I should be unsubscribed$/ do
  sleep 0.1
  events = @current_user.events.reload
  names = events.map(&:name)
  names.should_not include "Schwedisch 1"
end

Then(/^I should be subscribed to the event$/) do
  sleep 0.1
  @current_user.events.should include @event
end
