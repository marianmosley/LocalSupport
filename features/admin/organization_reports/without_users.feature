Feature: Orphans UI
  As the site owner
  So that I look up orphan orgs and email prospective users
  I want a UI that shows me orphan orgs and allows me to generate user accounts for them

  Background:
    Given the following organizations exist:
      | name               | address        | email             |
      | The Organization   | 83 pinner road | no_owner@org.org  |
      | The Same Email Org | 84 pinner road | no_owner@org.org  |
      | Crazy Email Org    | 30 pinner road | sahjkgdsfsajnfds  |
      | My Organization    | 30 pinner road | admin@myorg.com   |
      | Yet Another Org    | 30 pinner road | admin@another.org |
    And the following users are registered:
      | email                 | password       | admin | confirmed_at        | organization    | pending_organization |
      | nonadmin@myorg.com    | mypassword1234 | false | 2008-01-01 00:00:00 |                 |                      |
      | admin@myorg.com       | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |                      |
      | pending@myorg.com     | password123    | false | 2008-01-01 00:00:00 |                 | My Organization      |
      | invited-admin@org.org | password123    | false | 2008-01-01 00:00:00 |                 |                      |
<<<<<<< HEAD
    And cookies are approved
    And the admin invited a user for "Yet Another Org"
=======
    And the admin made a preapproved user for "Yet Another Org"
>>>>>>> 4e261d2ad24711ab392756d6cd98695dbf35fcc1

  @javascript
  Scenario: Admin can generate link but only for unique email
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the without users page
    And I check the box for "The Organization"
    And I check the box for "The Same Email Org"
    When I click id "invite_users"
    Then I should see "Invited!" in the response field for "The Organization"
    Then I should see "Error: Email has already been taken" in the response field for "The Same Email Org"

  @javascript
  Scenario: Select All button toggles all checkboxes
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the without users page
    And I press "Select All"
    Then all the checkboxes should be checked
    When I press "Select All"
    Then all the checkboxes should be unchecked

  @javascript
  Scenario: Admin should be notified when email is invalid
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the without users page
    And I check the box for "Crazy Email Org"
    When I click id "invite_users"
    Then I should see "Error: Email is invalid" in the response field for "Crazy Email Org"

  Scenario: As a non-admin trying to access orphans index
    Given cookies are approved
    Given I am signed in as a non-admin
    And I visit the without users page
    Then I should be on the home page
    And I should see "You must be signed in as an admin to perform this action!"

  Scenario: Invited user clicking through on email
    Given cookies are approved
    Given I click on the invitation link in the email to "admin@another.org"
    Then I should be on the invitation page
    And I fill in "user_password" with "12345678" within the main body
    And I fill in "user_password_confirmation" with "12345678" within the main body
    And I press "Set my password"
    Then I should be on the charity page for "Yet Another Org"

  Scenario: Pre-approved user clicking through on email and on cookies allow
    Given I click on the retrieve password link in the email to "admin@another.org"
    Then I should be on the password reset page
    And I click "Close"
    Then I should be on the password reset page
    And I fill in "user_password" with "12345678" within the main body
    And I fill in "user_password_confirmation" with "12345678" within the main body
    And I press "Change my password"
    Then I should be on the charity page for "Yet Another Org"

  @javascript
  Scenario: Table columns should be sortable
    Given cookies are approved
    Given I am signed in as an admin
    And I visit the without users page
    And I click tableheader "Name"
    Then I should see "Crazy Email Org" before "Yet Another Org"
    When I click tableheader "Name"
    Then I should see "Yet Another Org" before "Crazy Email Org"
