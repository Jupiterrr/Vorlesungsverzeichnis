Feature: Browsing static VVZ

Scenario: Navigate to an event
  Given a simple vvz hierarchy with an event
  And I am on the vvz page
  When I navigate to the event
  Then I see the event

Scenario: Navigate back with back_button
  Given a simple vvz hierarchy with an event
  And I am on the vvz page of the event
  When I click the back button
  Then I should be at the vvz root
