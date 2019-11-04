Feature: Deep link navigator push and pop
  Pages should be pushed onto and popped from the navigator stack.

  Scenario: Navigation starts with the default route
    Then the title is "Library"

  Scenario: Pushing to and popping from favorites page
    Given I open my favorite songs
    And the title is "My favorites (3)"
    When I go back 1 time
    Then the title is "Library"

  Scenario: Pushing to and popping favorites' song page
    Given I open my favorite songs
    And I open the song "Yesterday"
    And the title is "Yesterday"
    When I go back 1 time
    Then the title is "My favorites (3)"

  Scenario: Pushing to and popping artist page
    Given I open the artist "John Lennon"
    And the title is "John Lennon"
    When I go back 1 time
    Then the title is "Library"

  Scenario: Pushing to and popping artist's song page
    Given I open the artist "John Lennon"
    And I open the song "Yesterday"
    And the title is "Yesterday"
    When I go back 1 time
    Then the title is "John Lennon"

  Scenario: Pushing to an unknown route shows error page
    Given the title is "Library"
    When I tap the "Non-existant push" button
    Then the title is "ERROR"
    And the text "Route not found: [library, song/4312]" appears
    Then I go back 1 time
    And the title is "Library"