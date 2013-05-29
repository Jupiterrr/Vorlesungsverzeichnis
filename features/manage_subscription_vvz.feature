Feature: Manage Subscription @vvz

Background:
  Given I am logged in
  Given simple vvz
  Given I am on the "Schwedisch 1" vvz page

Scenario: Subscribe and Unsubscribe #static
  When I click "teilnehmen"
  Then I should be subscribed to "Schwedisch 1"
  Then I should see "abmelden"

  When I click "abmelden" within ".event"
  Then I should be unsubscribed
  Then I should see "teilnehmen"

@javascript
Scenario: Subscribe and Unsubscribe #js
  When I click "teilnehmen"
  Then I should be subscribed to "Schwedisch 1"
  Then I should see "abmelden" within ".event"

  Given I am on the "Schwedisch 1" vvz page
  When I click "abmelden" within ".event"
  Then I should be unsubscribed
  Then I should see "teilnehmen"
