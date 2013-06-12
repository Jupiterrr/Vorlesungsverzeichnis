Given /^I am logged in$/ do
  user = User.new uid: "test@user.edu", name: "Test User"
  user.disciplines.build name: "Mathe"
  user.save!
  visit "/backdoor"
  @current_user = user
end

Given /^a user with email "(.*?)"$/ do |mail|
  User.create uid: mail
end

When /^I sign in manually as "(.*?)" with password "(.*?)"$/ do |arg1, arg2|

end

Given /^I am signed in$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I click on my name in the header$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^a dicipline named "Informatik"$/ do
  Discipline.create name: "Informatik"
end

Then /^I shoud see an error message$/ do
  page.should have_css('.alert-error')
end
