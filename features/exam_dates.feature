
Feature: Manage Exam Dates

Background:
  Given I am logged in

Scenario: View Dates
  Given an exam date
  And I am on my exam dates page
  Then I should see the exam date

Scenario: Add Exam Date
  Given I am on my exam dates page
  When I click "Termin hinzufügen"
  And fill in the form and submit
  Then I should see the exam date

Scenario: Update Date
  Given an exam date
  And I am on the page of the exam date
  When I click "Bearbeiten"
  And I change the name and submit
  Then I should see the updated exam date