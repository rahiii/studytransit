Feature: View Space Capacity
  As a student
  I want to see the capacity of study spaces
  So that I can choose the right space for my study needs

  Background:
    Given there is a library "Butler" at "Columbia University"
    And the library has the following spaces:
      | name        | capacity |
      | Room 209    | 3        |
      | Butler Cafe | 3        |
      | Main Room   | 2        |
      | 4th Floor   | 4        |

  Scenario: View capacity indicators for all spaces
    Given I am on the library page for "Butler"
    When I view the spaces
    Then I should see "Room 209" with capacity "3/5"
    And I should see "Butler Cafe" with capacity "3/5"
    And I should see "Main Room" with capacity "2/5"
    And I should see "4th Floor" with capacity "4/5"

  Scenario: See person icons representing capacity
    Given I am on the library page for "Butler"
    When I view the spaces
    Then I should see 3 person icons for "Room 209"
    And I should see 3 person icons for "Butler Cafe"
    And I should see 2 person icons for "Main Room"
    And I should see 4 person icons for "4th Floor"

  Scenario: View spaces with no capacity set
    Given there is a library "Avery" at "Columbia University"
    And the library has a space "New Space" with no capacity
    When I am on the library page for "Avery"
    And I view the spaces
    Then I should see "New Space" with capacity "Not set"
    And I should see 0 person icons for "New Space"

  Scenario: Navigate back to library list from capacity view
    Given I am on the library page for "Butler"
    When I click the back arrow
    Then I should be on the libraries index page
    And I should see "Butler" in the library list
