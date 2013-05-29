@wip
Feature: User authentication

@wip
Scenario: User logs in
  Then pending
#   Given a user with email "test@mail.com"
#   When I sign in manually as "ohai" with password "secret"
#   Then I should be on the stream page

@wip
Scenario: User logs out
  Then pending
  # Given I am signed in
  # And I click on my name in the header
  # And I follow "Log out"
  # Then I should be on the new user session page


Scenario: User logs in for the first time
  Given a vvz node hierarchy "Node1", "Node2" and and event "Schwedisch 1"
  Given a dicipline named "Informatik"
  Given I am logged in
  Then I should be on the signup page

  When I fill in "Name" with "Peter Pan"
  When I press "Anmelden"
  Then I should be on the signup page
  Then I shoud see an error message

  When I select "Informatik" from "Studiengang"
  When I press "Anmelden"
  Then I should be on the dasboard page