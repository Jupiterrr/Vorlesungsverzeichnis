Feature: Export Timetable dates
  In order to view my dates in my favorit calender app
  As a user
  I want to export my timetable
  
Scenario: Get export url
  Given I am logged in
  Given a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1" 
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