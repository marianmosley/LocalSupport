Feature: I want to be able to edit static pages
  As a user
  So that I can not suffer from the crushing pain of infinite redirects
  I want to be redirected to the correct page after I sign in
  Tracker story ID: https://www.pivotaltracker.com/story/show/

  Background: organizations have been added to database
    Given the following pages exist:
      | name       | permalink  | content                                                   |
      | Disclaimer | disclaimer | We disclaim everything!                                   |
      | 404        | 404        | We're sorry, but we couldn't find the page you requested! |
    Given the following organizations exist:
      | name     | address        |
      | Friendly | 83 pinner road |
    And the following users are registered:
      | email             | password | admin  | confirmed_at         |  organization |
      | user1@example.com | pppppppp | false  | 2007-01-01  10:00:00 |  Friendly     |

  Scenario: visit public routes
    Given public routes "1"

