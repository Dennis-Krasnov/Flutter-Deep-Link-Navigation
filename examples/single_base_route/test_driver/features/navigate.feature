Feature: Deep link navigator direct navigation
  Routes should be accessed from any other route.

  Scenario: Navigation from artists' song page to artist page
    Given I open the artist "John Lennon"
    And I open the song "Yesterday"
    And the title is "Yesterday"
    When I navigate to the song's artist
    Then the title is "John Lennon"
    # Once like normal
    Then I go back 1 time
    And the title is "Library"

  Scenario: Navigation from favorites' song page to artist page
    Given I open my favorite songs
    And I open the song "Yesterday"
    And the title is "Yesterday"
    When I navigate to the song's artist
    Then the title is "John Lennon"
    # Once instead of twice
    Then I go back 1 time
    And the title is "Library"

  Scenario: Navigation to an unknown route shows error page
    Given the title is "Library"
    When I tap the "Non-existant navigate" button
    Then the title is "ERROR"
    And the text "Route not found: [library, song/6363]" appears
    Then I go back 1 time
    And the title is "Library"