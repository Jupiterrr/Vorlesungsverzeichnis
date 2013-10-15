Given(/^an Event$/) do
  @event = FactoryGirl.create(:event)
end

When(/^I edit the description$/) do
  click_link("bearbeiten")
  @new_description = "bla bla bla"
  fill_in("event[user_text_md]", with: @new_description)
  click_button("Speichern")
end

Then(/^I should see the updated description$/) do
  page.should have_content(@new_description)
end
