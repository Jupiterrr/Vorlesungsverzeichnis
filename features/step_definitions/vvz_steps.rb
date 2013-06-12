When /^I click the back button$/ do
  find('.back').click
end

When /^I open "(.*?)" in an new Tab$/ do |arg1|
  url = find('a', :text => arg1)[:href]
  visit url
end

Given(/^a simple vvz hierarchy with an event$/) do
  current_term = "SS_2013"
  node = Vvz.create name: "KIT"
  node = node.children.create name: current_term
  node = node.children.create name: "Node1"
  node = node.children.create name: "Node2", is_leaf: true
  @event = node.events.create name: "Schwedisch 1", _type: "type", term: current_term
end

When(/^I navigate to the event$/) do
  click_link "Node1"
  click_link "Node2"
  click_link "Schwedisch 1"
end

Then(/^I see the event$/) do
  with_scope(".event h1") do
    page.should have_content(@event.name)
  end
end