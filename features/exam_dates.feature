@wip
Feature: Manage Exam Dates

Background:
  Given I am logged in
  Given I am on the exam dates page
  Given Disciplines: Informatik

Scenario: View Dates
  Given I am logged out
  Given a exam date named "Salatwettessen", "15.09.2013"
  Given I am on the exam dates page
  Then I should see "Salatwettessen"
  And I should see "15.09.2013"

Scenario: Add Exam Date
  When I click "Termin hinzufügen"
  And I select "Informatik" from "exam_date_discipline_id"
  And I fill in "exam_date_name" with "Informatik Hauptklausur"
  And press "Speichern"
  Then I should see "Informatik Hauptklausur"
