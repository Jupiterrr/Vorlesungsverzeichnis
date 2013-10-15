@wip
Feature: Timetable

Background:
  Given I am logged in
  And the current date is "05.11.2012"
  And a simple vvz hierarchy with an event

# @javascript
# @allow-rescue
# Scenario: Show timetable
#   Given an "Schwedisch 1" event
#   And the event has following dates:
#     | start | end   |
#     | 14:00 | 15:00 |
#     | 10:00 | 11:30 |
#   And I attend "Schwedisch 1"
#   When I go to the timetable page
#   Then debug
#   Then I should see "Schwedisch 1" within "#calendar"
#   And I should see "14:00 - 15:00" within "#calendar"
#   And I should see "10:00 - 11:30" within "#calendar"

# @javascript
# Scenario: Click Date
#   Given an "Schwedisch 1" event
#   And the event has following dates:
#     | start | end   |
#     | 14:00 | 15:00 |
#   And I attend "Schwedisch 1"
#   When I go to the semester page
#   When I click on "Schwedisch 1" within "#calendar"
#   #Then debug
#   Then I should be on the "Schwedisch 1" event page



