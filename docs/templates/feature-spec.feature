Feature: <short name>
  <One paragraph: who needs this and what it gives them.>

  Background:
    Given <common precondition>

  Rule: <the business rule this group enforces>

  Scenario: <concrete happy path>
    Given <exact state with concrete values>
    When <one user or system action>
    Then <observable outcome with concrete values>

  Scenario: <edge case or failure mode>
    Given <state that stresses a boundary>
    When <action>
    Then <specific error or behavior>
