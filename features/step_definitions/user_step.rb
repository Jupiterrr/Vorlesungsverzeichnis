
Then /^I should be subscribed to "Schwedisch 1"$/ do
  sleep 0.1
  events = @current_user.events
  names = events.map(&:name)
  names.should include "Schwedisch 1"
end

Then /^I should be unsubscribed$/ do
  sleep 0.1
  events = @current_user.events.reload
  names = events.map(&:name)
  names.should_not include "Schwedisch 1"
end