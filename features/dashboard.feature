Feature: Dashboard

Background: 
  Given a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1" 
  And I am logged in
  And I am on the dashboard page

# Scenario: New Activity shows up
#   Given 
#   When I click "Node2"
#   When I click "Schwedisch 1"
#   Then I see the "Schwedisch 1" vvz_event page

@wip
Scenario: What happens if user attends no events
  Then pending

@wip
Scenario: User attends event that is tomorrow
  Then pending

@wip
Scenario: Redirect user to the select view if he has no event selected