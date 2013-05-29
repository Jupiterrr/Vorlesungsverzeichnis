Feature: Browsing static VVZ

Background: 
  Given a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1" 
  And I am on the vvz page

Scenario: Navigate to event
  When I click "Node1"
  When I click "Node2"
  When I click "Schwedisch 1"
  Then I see the "Schwedisch 1" vvz_event page

# @wip
# Scenario: Navigate back with back_button
#   Given I navigated to the "Schwedisch 1" vvz_event page
#   When I click the back button
#   Then I see "Node 1"
