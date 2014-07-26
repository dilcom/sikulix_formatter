Feature: Change text properties
  As a user
  I want to change properties of selected text
  In order to make my text less or more readable

  Background:
    Given text fragment selected
    And menu opened by click on "1400188760887.png"

  Scenario: user changes the case
    Given submenu opened by hover "1400350284909.png"
    When I click on "1400350576310.png"
    Then I should see "1401099724885.png"

  Scenario Outline: user chooses garniture and size by filling
    Given window opened by click on "1401098332746.png"
    And tab opened by click on "1401096173233.png"
    When I fill in <field> with <string>
    And confirm window by click on "1401098439831.png"
    Then I should see <effect img>
  Examples:
    |field            |string      |effect img       |
    |Pattern("1401098705948.png").targetOffset(-25,25)|Segoe Script|"1401099021597.png"|
    |Pattern("1401098838926.png").targetOffset(-25,25)|20          |"1401099724885.png"|