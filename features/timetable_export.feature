Feature: Export Timetable dates

Scenario: Get export url
  Given a simple vvz hierarchy with an event
  Given I am logged in
  When I go to the timetable page
  Then I see my ical url within ".ical_url"

# Scenario: Download ical file
#   Given a User attending "Schweidsch 1"
#   When I go to ical url of that user
#   Then I see an ical file
#   And I see "Schweidsch 1"

# Scenario: Change URL
#   When I click "URL zurücksetzen"
#   Then I should see a new url
