Feature: Select a library to view its rooms
  As a student
  I want to click a library
  So that I can see its rooms (spaces)

  Background:
    Given a library named "Butler Library" at "Columbia University"
    And "Butler Library" has spaces:
      | name               | capacity |
      | Main Reading Room  | 3        |
      | Talking Room       | 1        |
    And a library named "Avery Library" at "Columbia University"
    And "Avery Library" has spaces:
      | name               | capacity |
      | Upstairs           | 3        |
      | Downstairs         | 1        |

  Scenario: Loading the library page
    Then there should be 2 libraries in the database

  Scenario: Selecting Butler Library shows its rooms
    Given I am on the libraries page
    When I click on "Butler Library"
    Then I should be on the library page for "Butler Library"
    And I should see the room "Main Reading Room"
    And I should see the room "Talking Room"