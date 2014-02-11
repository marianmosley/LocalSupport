Feature: This is my organization
  As a organization administrator
  So that I could be set as an admin of our organization
  I want to be able to request for the privilege through our organization page

  Background:
    Given the following organizations exist:
      | name             | address        |
      | The Organization | 83 pinner road |
    And the following users are registered:
      | email              | password       | admin | confirmed_at        | organization     | pending_organization |
      | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                  |                      |
      | pending@myorg.com  | mypassword1234 | false | 2008-01-01 00:00:00 |                  | The Organization     |
      | admin@myorg.com    | mypassword1234 | false | 2008-01-01 00:00:00 | The Organization |                      |
    And cookies are approved

  Scenario: I am a signed in user who requests to be admin for my organization
    Given I am on the charity page for "The Organization"
    And I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then I should see a link or button "This is my organization"
    And I click "This is my organization"
    Then I should be on the charity page for "The Organization"
    And "nonadmin@myorg.com"'s request status for "The Organization" should be updated appropriately

  Scenario: I am a signed in user who has a pending request to be admin for my organization
    Given I am on the charity page for "The Organization"
    And I sign in as "pending@myorg.com" with password "mypassword1234"
    When I am on the charity page for "The Organization"
    Then I should not see a link or button "This is my organization"

  Scenario: I am a signed in charity admin for my organization
    Given I am on the charity page for "The Organization"
    And I sign in as "admin@myorg.com" with password "mypassword1234"
    When I am on the charity page for "The Organization"
    Then I should not see a link or button "This is my organization"

  @javascript
  Scenario: I am not signed in, I will be offered "This is my organization" claim button
    Given I am on the charity page for "The Organization"
    Then I should see "This is my organization"
    When I click id "TIMO"
    Then show me the page
    Then I should be on the charity page for "The Organization"
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    And "nonadmin@myorg.com"'s request status for "The Organization" should be updated appropriately
    Then I should be on the charity page for "The Organization"

  @javascript
  Scenario: I am not a registered user, I will be offered "This is my organization" claim button
    When I am on the charity page for "The Organization"
    Then I should see "This is my organization"
    When I click id "TIMO"
    When I click "toggle_link"
    And I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    Then I should be on the home page
    And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    Then I should be on the charity page for "The Organization"
    And "normal_user@myorg.com"'s request status for "The Organization" should be updated appropriately
