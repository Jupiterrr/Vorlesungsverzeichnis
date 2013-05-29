Given /^a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1"$/ do

  node = Vvz.create name: "KIT"
  node = node.children.create name: "term"
  node = node.children.create name: "Node1"
  node = node.children.create name: "Node2", is_leaf: true
  node.events.create name: "Schwedisch 1", _type: "type"
end

Then /^I see the "Schwedisch 1" vvz_event page$/ do
  with_scope(".spalte .event") do
    page.should have_content("Schwedisch 1")
  end
end

When /^I click the back button$/ do
  find('.back').click
end

When /^I open "(.*?)" in an new Tab$/ do |arg1|
  url = find('a', :text => arg1)[:href]
  visit url
end

Given /^simple vvz$/ do
  current_term = "SS_2013"
  node = Vvz.create name: "KIT"
  node = node.children.create name: current_term
  node = node.children.create name: "Node1"
  node = node.children.create name: "Node2", is_leaf: true
  node.events.create name: "Schwedisch 1", _type: "type", term: current_term
end