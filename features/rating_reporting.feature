Feature: Crowdsourced Rating Reporting
  As a student
  I want to see how full a study space is based on crowdsourced reports
  So that I can find available study spaces

  Background:
    Given there is a library "Butler" at "Columbia University"
    And the library has the following spaces:
      | name      | capacity |
      | Main Room | 3        |
      | Room 209  | 2        |

  Scenario: View space with ratings
    Given I am on the library page for "Butler"
    And "Main Room" has ratings:
      | value |
      | 4     |
      | 5     |
    When I view the spaces
    Then "Main Room" should show an average rating
    And I should see when the rating was last updated

  Scenario: View space with no ratings
    Given there is a library "Avery Library" at "Columbia University"
    And the library has a space "New Space" with no capacity
    When I am on the library page for "Avery Library"
    Then "New Space" should show "No recent ratings"

  Scenario: View capacity update timestamp
    Given I am on the library page for "Butler"
    When I update "Main Room" capacity to "4"
    Then I should see when the capacity was last updated
    And the timestamp should show the update time

