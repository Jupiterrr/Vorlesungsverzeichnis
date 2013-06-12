Given(/^Disciplines: Informatik$/) do
  Discipline.create name: "Informatik"
end

Given(/^I am logged out$/) do
  visit "/signout"
end
