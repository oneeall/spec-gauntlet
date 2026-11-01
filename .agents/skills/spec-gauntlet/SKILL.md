---
name: spec-gauntlet
description: Run the five-stage "agent gauntlet" development pipeline (Spec Writer, Coder, Cleaner, Hardener, QA) with a deterministic machine-checkable gate at the end of every stage, based on Robert C. Martin (Uncle Bob)'s spec-driven AI workflow. Use whenever the user asks to build or add a feature, create a new module or app, says "use the gauntlet", "spec gauntlet", "uncle bob workflow", "spec-driven", wants disciplined AI-agent development, or asks how to structure feature work with AI — even for small features where tests matter.
license: Adapted from the public conversation "LIVE: Uncle Bob on Software Fundamentals in the Age of AI" (Matt Pocock, 2026)
---

# Uncle Bob's Agent Gauntlet

Turn requirements into verified code through five single-purpose stages. Each stage ends in a **gate** — an objective, machine-checkable result. If a gate fails, fix the work in that stage; never carry a failure forward and never compensate with longer instructions.

The division of labor: **the human writes specifications, the agent writes code, gates enforce quality.** Your job is to run the pipeline and be judged by the gates — not to be steered by long prompts.

## When to run this

- A new feature, module, screen, API, or app.
- A bug fix that deserves a regression test (Stage 1 becomes "write a failing scenario that reproduces the bug").
- Skip it for throwaway scripts, config tweaks, or one-line cosmetic changes — the gauntlet costs more than it protects there.

If the user hasn't given you a written requirement, ask for one short paragraph of intent, then start Stage 1 yourself.

## The two rules that make it work

1. **The spec is the contract, not the prompt.** Intent is frozen into executable form (Gherkin `Given/When/Then`) before any production code exists. Every later disagreement is settled by running a test, not by re-reading a conversation.
2. **Keep every stage's context minimal.** Long prompts fail silently ("lost in the middle" — models under-weight instructions buried mid-prompt). Each stage receives only the artifacts it needs: the spec for the coder, the diff for the cleaner, the suite for the hardener. Prefer dispatching a stage to a fresh subagent with a short, artifact-focused prompt over accumulating one long session.

## Pipeline overview

| Stage | Role | Ends when (gate) |
|---|---|---|
| 1. Spec Writer | requirements → Gherkin acceptance tests + QA script | Scenarios exist, are concrete and runnable-intent, user confirms they capture intent |
| 2. Coder | implementation + unit tests, function by function | All unit tests green |
| 3. Cleaner | CRAP/complexity analysis + code review pass | Complexity capped, review comments resolved |
| 4. Hardener | mutation testing | Mutation score at or above threshold (mutants killed) |
| 5. QA | end-to-end run of the QA script / UI tests | End-to-end pass on the assembled system |

## Stage 1 — Spec Writer

Goal: turn ambiguous requirements into concrete, verifiable tests.

1. Read the requirement. Interrogate it: what is the happy path, the edge cases, the failure modes?
2. Write Gherkin features under `specs/` (or `docs/specs/`), one `.feature` file per capability:

   ```gherkin
   Feature: Password reset
     Rule: reset links expire after 15 minutes
     Scenario: Expired link is rejected
       Given a reset link generated 16 minutes ago
       When the user opens the link
       Then they see "link expired" and can request a new one
   ```

3. Write a **QA script** (`specs/FEATURE.qa.md`): the ordered manual/UI procedure a human or UI driver would run against the assembled system, with expected observations per step.
4. Gate: every scenario names concrete inputs and observable outcomes (no "works correctly"), and the user agrees the scenarios are the intent. Ask for confirmation explicitly — this is the one gate only a human can close.

If Gherkin specs for this feature already exist, verify they still match the request and skip to Stage 2.

## Stage 2 — Coder

Goal: make the acceptance scenarios true, with unit tests, working **function by function** — not test-first ceremony.

Uncle Bob's point here: TDD (red-green-refactor as a design discipline) is for humans designing under uncertainty. An agent iterates differently: take one function or small slice of behavior, write its unit tests and implementation together, run them, fix, move to the next. The acceptance spec from Stage 1 is already the design contract.

1. Work from the Gherkin scenarios. Map each scenario to the module boundary it implies (the human owns architecture decisions; propose, don't silently decide, anything structural).
2. Implement slice by slice; keep each unit test focused and fast. Run the suite constantly.
3. Gate: `./gradlew test` / `npm test` / `go test ./...` — the project's unit-test command exits green, including a mapping of every acceptance scenario to at least one test.

## Stage 3 — Cleaner

Goal: eliminate the debt the coder left behind, measured not guessed.

1. Run the project's complexity/coverage tooling and compute CRAP where possible: `CRAP = cyclomatic_complexity² × (1 − coverage)³ + cyclomatic_complexity`. Tooling per platform is in `references/gates.md`.
2. Refactor hotspots: extract functions, collapse branches, delete duplication — behavior locked by the now-green tests.
3. Run a code-review pass over the new diff (lint, then read it as a reviewer): naming, module boundaries, dead code, error handling.
4. Gate: no function in the changed code exceeds cyclomatic complexity ~10, lint is clean, and every review comment you raise is either fixed or explicitly waived by the user.

## Stage 4 — Hardener

Goal: prove the test suite actually catches bugs, not just executes code.

1. Run mutation testing on the changed code (flips operators, alters constants, inverts conditions; a good suite kills the mutants). Tooling per platform is in `references/gates.md`.
2. For every surviving mutant: either add/strengthen the test that kills it, or justify why that behavior is untestable/not worth testing.
3. Gate: mutation score ≥ ~80% on the changed code (or the best the platform's tooling supports), with survivors justified.

If no mutation tool exists for the platform, do a manual hardening sweep: for each branch and boundary condition in the diff, verify a test would fail if it were inverted — and write that test.

## Stage 5 — QA

Goal: verify the assembled system, end to end.

1. Execute the QA script from Stage 1 against the real app (UI/instrumented tests, or driven manually with the user if no automation exists).
2. Record each step's observed result against its expected result.
3. Gate: every step passes on the assembled system. Any failure goes back to Stage 2 with a failing scenario added to the spec first.

## Reporting

When a stage's gate passes, say so in one line with the evidence (command + result). When reporting completion of the whole pipeline, summarize: what the spec froze, what the gates proved (tests green, complexity capped, mutation score, E2E pass), and what remains human judgment.

## References

- `references/gates.md` — concrete gate tooling per platform (JVM/Android, JS/TS, Go, Rust, Python), including CRAP computation and mutation-testing setup.
- `references/templates.md` — Gherkin spec template, QA script template, and minimal per-stage dispatch prompts for ephemeral subagents.
