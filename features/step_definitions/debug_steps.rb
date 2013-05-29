Then /^show$/ do
  save_and_open_page
end

Then /^screenshot$/ do
  if Capybara.current_session.driver.is_a? Capybara::RackTest::Driver
    #page.save_screenshot('tmp/screenshot.png')
    save_and_open_page
  else 
    sleep 2
    page.driver.render('tmp/screenshot.png', :full => true)
  end
  `open tmp/screenshot.png`
end

Then /^debug$/ do
  page.driver.debug
end

Then /^pry$/ do
  binding.pry
end

When /^I wait (\d+(?:\.\d+)?)?$/ do |seconds|
  sleep seconds.to_f
end

Then /^`(.*)`$/ do |code|
  eval code
end

Then /^sleep (\d+(?:\.\d+)?)?$/ do |seconds|
  sleep seconds.to_f
end