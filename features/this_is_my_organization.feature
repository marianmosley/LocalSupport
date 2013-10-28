Feature: This is my organization
  As a organization administrator
  So that I could be set as an admin of our organization
  I want to be able to request for the privilege through our organization page

  Background:
    Given the following organizations exist:
    | name            | address        |
    | My Organization | 83 pinner road |

    And the following users are registered:
    | email              | password       | admin | confirmed_at        | organization    | charity_admin_pending |
    | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 | false                 |
    | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization | false                 |
    | pending@myorg.com  | password123    | false | 2008-01-01 00:00:00 |                 | true                  |


  Scenario: I am an user who has not signed in and requests to be admin of my organization
    Given I am not signed in as any user

    # The following might be even more declarative
    #And I request ownership of "My Organization"
    #Then my request should be persisted during login
    #And my request status for "My Organization" should be updated appropriately

    And I am on the charity page for "My Organization"
    Then I should see the "This is my organization" button for "My Organization"
    When I press "This is my organization"
    Then I should be on the sign in page
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then "nonadmin@myorg.com"'s request status for "My Organization" should be updated appropriately
    
  Scenario: I am a signed in user who requests to be admin for my organization
    Given I am on the sign in page
    And I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    When I am on the charity page for "My Organization"
    And I press "This is my organization"
    Then I should be on the charity page for "My Organization"
    And "nonadmin@myorg.com"'s request status for "My Organization" should be updated appropriately
    # And flags listed below must be set for user
    # user.charity_admin_pending will be set to TRUE here
    # user.pending_organization_id is set for their charity

  #Scenario: A site admin has approved my request so I my homepage is the charity
  #  Given that an admin has approved the request
  #  And I am on the sign in page
  #  And I sign in as "nonadmin@myorg.com" with password "mypassword1234"
  #  Then I should be on the charity page for "My Organization"
  #  And I should not see the "This is my organization" button for "My Organization"


    # 1. could make even more declarative
    # 2. write additional feature to handle approved case
    # 3. refactor view to use button_to_if
    # 4. make sure we have appropriate view and model specs
    # 5. could remove the charity_admin_pending flag