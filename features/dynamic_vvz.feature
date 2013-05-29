@wip
@javascript
Feature: Browsing dynmic VVZ

Background:
  Given a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1"
  And I am on the vvz page

Scenario: Navigate to event
  When I click "Node1"
  When I click "Node2"
  When I click "Schwedisch 1"
  Then I see the "Schwedisch 1" vvz_event page

Scenario: Navigate back with back_button
  Given I am on the "Schwedisch 1" vvz_event page
  When I click the back button
  Then I should see "Node1"

Scenario: Open in new Tab
  When I click "Node1"
  When I open "Node2" in an new Tab
  Then I should see "Schwedisch 1"

  When I open "Schwedisch 1" in an new Tab
  Then I see the "Schwedisch 1" vvz_event page
