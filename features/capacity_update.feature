Feature: Update Space Capacity
  As a user
  I want to update the capacity of a study space
  So that I can indicate how many people the space can accommodate

  Background:
    Given the following libraries exist:
      | name   | location          |
      | Butler | Columbia University|
    And the following spaces exist:
      | name      | capacity | library |
      | Main Room | 2        | Butler  |
      | Room 209  | 1        | Butler  |

  Scenario: Successfully update a space capacity with valid value
    Given I am on the Butler library page
    When I fill in "1" for the first space capacity
    And I press "Update Capacity" for the first space
    Then I should be on the Butler library page
    And the first space should show capacity "1/5"

  Scenario: Successfully update capacity from 1 to 3
    Given I am on the Butler library page
    When I fill in "3" for "Main Room" capacity
    And I press "Update Capacity" for "Main Room"
    Then "Main Room" should show capacity "3/5"

  Scenario: Fail to update with capacity below minimum
    Given I am on the Butler library page
    When I fill in "0" for the first space capacity
    And I press "Update Capacity" for the first space
    Then the error should say "must be between 1 and 5"

  Scenario: Fail to update with capacity above maximum
    Given I am on the Butler library page
    When I fill in "6" for the first space capacity
    And I press "Update Capacity" for the first space
    Then the error should say "must be between 1 and 5"

  Scenario: Display correct capacity indicator icons
    Given I am on the Butler library page
    Then "Main Room" should display 2 capacity icons
    And "Room 209" should display 1 capacity icons
    When I update "Room 209" capacity to "3"
    Then "Room 209" should display 3 capacity icons

  Scenario: View capacity for space without capacity set
    Given the following spaces exist:
      | name       | library |
      | Quiet Room | Butler  |
    And I am on the Butler library page
    Then "Quiet Room" should show "Not set" for capacity

