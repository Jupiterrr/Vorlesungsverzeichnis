Feature: Manage Subscription @vvz

Background:
  Given a simple vvz hierarchy with an event
  Given I am logged in
  Given I am on the vvz event page

Scenario: Subscribe and Unsubscribe #static
  When I click "teilnehmen"
  Then I should be subscribed to the event
  Then I should see "abmelden"
  When I click "abmelden" within ".event"
  Then I should be unsubscribed
  Then I should see "teilnehmen"

@javascript
Scenario: Subscribe and Unsubscribe #js
  When I click "teilnehmen"
  Then I should be subscribed to the event
  Then I should see "abmelden" within ".event"

  Given I am on the vvz event page
  When I click "abmelden" within ".event"
  Then I should be unsubscribed
  Then I should see "teilnehmen"
