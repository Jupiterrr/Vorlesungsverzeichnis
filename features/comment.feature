@wip
Feature: Comment to Post

Background:
  Given an Event
  And I am logged in
  And I am subscribed to the Event
  And I am allowed to use post feature
  And I am on the event page
  And a post for the event

@javascript
Scenario: Comment
  When I write a comment and submit it
  Then I see the comment

@javascript
Scenario: Delete Post
  Given a comment I wrote
  When I delete the comment
  Then the comment should dissapear
