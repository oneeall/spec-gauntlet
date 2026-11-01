# Templates

## Gherkin acceptance spec — `specs/<feature>.feature`

```gherkin
Feature: <short name>
  <One paragraph: who needs this and what it gives them.>

  Background:
    Given <common precondition>

  Rule: <the business rule this group enforces>

  Scenario: <concrete happy path>
    Given <exact state with concrete values>
    When <one user/system action>
    Then <observable outcome with concrete values>

  Scenario: <edge case or failure mode>
    Given <state that stresses a boundary>
    When <action>
    Then <specific error/behavior>
```

Quality bar: every `Given`/`Then` uses concrete values ("16 minutes ago", `"link expired"`), never "works", "is valid", "is handled".

## QA script — `specs/<feature>.qa.md`

```markdown
# QA procedure — <feature>

Environment: <build variant, device/browser, seed data>

1. Step: <exact user action>
   Expect: <exactly what the tester should see>
2. Step: ...
   Expect: ...

Result: PASS/FAIL per step, recorded at Stage 5.
```

## Ephemeral stage dispatch prompts

Each stage gets a fresh agent with a short prompt and only the artifacts it needs. Never paste the whole conversation history into a stage prompt — that reintroduces the lost-in-the-middle problem the gauntlet exists to avoid.

- **Stage 2 (Coder):** "Implement `specs/reset.feature` in `<module>`. Work function by function, write unit tests with each slice, run `<test command>` until green. Do not change module boundaries; propose them if the spec forces a choice."
- **Stage 3 (Cleaner):** "Here is the diff `<path/range>` and the coverage/complexity report `<path>`. Refactor anything over cyclomatic complexity 10 or CRAP ≥ 30, keeping `<test command>` green. Then review the diff and list every issue found; fix or explicitly waive each."
- **Stage 4 (Hardener):** "Run `<mutation command>` on the changed code. For every surviving mutant, strengthen or add a test that kills it, or state why it is not worth testing. Report the final score."
- **Stage 5 (QA):** "Execute `specs/<feature>.qa.md` against the app. Record observed vs expected for every step; report PASS/FAIL per step."
