Feature: Manage Event Dates

Background:
  Given a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1" 
  Given I am logged in

Scenario: Add Exam Date
  Given an event named "Mathe"
  Given I am on the "Mathe" event page
  When I click "Termine"
  When I click "add-exam-date"
  When I press "Speichern"
  Then I should see "Termin erfolgreich gespeichert."
