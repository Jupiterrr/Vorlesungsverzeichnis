@wip
Feature: Post to Event

Background:
  Given an Event
  And I am logged in
  And I am subscribed to the Event
  And I am allowed to use post feature
  And I am on the event page

@javascript
Scenario: Post
  When I write a post
  And submit it
  Then I should see it

@javascript
Scenario: Delete Post
  Given a post I have written
  When I delete the post
  Then the post should dissapear

# @javascript
# @wip
# Scenario: Revert Delete Post
#   Given a post I have written
#   When I click delete
#   Then I should see the undo dialog
#   When I click undo
#   Then I

# @javascript
# Scenario: Post Pagination
#   Then pending
