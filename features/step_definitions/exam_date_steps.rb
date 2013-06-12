# encoding: UTF-8

Given(/^an exam date$/) do
  discipline = @current_user.disciplines.first
  @exam_date = discipline.exam_dates.create name: "Salatwettessen", date: DateTime.new(2013, 1, 1)
end

Then(/^I should see the exam date$/) do
  page.should have_content("Salatwettessen")
  page.should have_content("01.01.2013")
end

When(/^fill in the form and submit$/) do
  fill_in("exam_date_name", :with => "Salatwettessen")
  fill_in("exam_date_date", :with => "1.1.2013")
  click_button("Speichern")
end



When(/^I change the name and submit$/) do
  fill_in("exam_date_name", :with => "Bauchwehselbsthilfeabschlussprüfung")
  fill_in("exam_date_date", :with => "5.9.2013")
  click_button("Speichern")
end

Then(/^I should see the updated exam date$/) do
  page.should have_content("Bauchwehselbsthilfeabschlussprüfung")
  page.should have_content("05.09.2013")
end

