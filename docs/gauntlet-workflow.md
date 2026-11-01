# The Agent Gauntlet — study digest and working workflow

Source: "LIVE: Uncle Bob on Software Fundamentals in the Age of AI" — Matt Pocock, 56:40 (youtube.com/watch?v=zcLPGC-tvgk). Timestamps below refer to that video.

## 1. Why fundamentals matter *more* now

When most code is typed by AI agents, the bottleneck moves: generation is cheap, judgment is scarce. A human who can't read a test suite critically can't tell whether an agent's output is sound — and everything downstream inherits that blindness. Uncle Bob's position: the practices codified in *Clean Code* become the **specification layer** humans own, while the typing is delegated.

Two failure modes motivate the pipeline design:

- **Long steering prompts fail silently.** The "lost in the middle" effect (13:58): LLMs under-weight context buried in the middle of long prompts, so rules hidden there get ignored exactly when they matter. More instructions ≠ more control.
- **Long-running agent sessions accumulate confusion.** One agent holding twenty minutes of conversation drifts; fresh, ephemeral instances per task (19:50) keep every stage working from clean, relevant context.

## 2. Vocabulary that carries the argument

| Term | Meaning as used |
|---|---|
| **CRAP score** (Change Risk Anti-Patterns) | `complexity² × (1 − coverage)³ + complexity` — complex code with weak tests scores worst; it tells you where refactoring hurts most. |
| **Mutation testing** | Deliberately inject bugs (flip operators, change constants); a robust suite *kills the mutants*. Proves tests catch bugs, not just execute code. |
| **Lost in the middle** | LLM attention drops for context buried mid-prompt — the argument against steering agents with long instructions. |
| **Tactical vs strategic** (Ousterhout) | Tactical = implement the immediate feature fastest; strategic = invest in architecture and system design. The strategic layer stays human. |
| **Ephemeral agents** | Fresh agent instance per task; confused trajectories never accumulate in one context window. |

## 3. The five-stage gauntlet

Requirements become a finished, verified module through five single-purpose agents. The human writes documents; each stage ends in a **deterministic gate** — an objective, machine-verifiable result — so quality is enforced by tooling, not by instruction-following.

| Stage | Goal | Actions | Gate (result) |
|---|---|---|---|
| **1 — Spec Writer** (20:21) | Turn ambiguous requirements into concrete, verifiable tests | Agent converts human documents into Gherkin + a human-operated QA procedure | Executable acceptance tests + QA roadmap; **human confirms intent** |
| **2 — Coder** (21:09) | Build the feature with focused context | Coder agent writes unit tests and implementation from the spec | Working code, all unit tests passing |
| **3 — Cleaner** (21:30) | Eliminate technical debt automatically | CRAP analysis + code-review pass over the new code | Complexity capped, review comments resolved |
| **4 — Hardener** (21:45) | Guarantee coverage is *meaningful* | Mutation testing against the codebase | Suite proven to catch injected bugs |
| **5 — QA Agent** (22:07) | Verify system-wide functionality | Executes the QA script against the UI | End-to-end pass on the assembled system |

Two design choices make it work:

1. **The spec is the contract.** Intent is frozen into Gherkin at stage 1, so every later disagreement is settled by *running a test*, not re-reading a prompt.
2. **Agents are ephemeral and narrow.** Each starts clean, receives exactly the artifacts it needs, hands output to the next gate. Nothing depends on remembering instructions from earlier conversation.

## 4. Positions from the Q&A

- **Why not steer with long instructions?** Lost-in-the-middle; deterministic gates replace instruction volume. (13:58)
- **Why ephemeral agents?** Long sessions accumulate confused trajectories; fresh instances per task stay clean. (19:50)
- **Are fundamentals dead?** No — more important than ever; they're what lets a human judge the machine's output. (53:06)
- **How do juniors become strategic?** Be the agent for a few months: do the work manually under strict, deterministic constraints — that builds the judgment strategic programming requires. (47:30)
- **Is TDD right for agents?** No. TDD is a *human* discipline for designing under uncertainty. Agents work function by function, iterating against already-specified tests. (34:30)

## 5. Running the workflow (operational form)

This is the pipeline restated as something you actually do, with ZCode or any coding agent. The matching skill is `spec-gauntlet`, installed from this repo (`.agents/skills/spec-gauntlet/`, wired into `~/.zcode/skills/` by `install.sh`) and triggers on feature work automatically.

### Stage 1 — Spec Writer
Write (or have the agent draft from your paragraph, then edit) `specs/<feature>.feature` in Gherkin and `specs/<feature>.qa.md` as a step/expect QA procedure. **Gate:** every scenario uses concrete values; you agree the scenarios *are* the intent. This is the only gate a human closes personally.

### Stage 2 — Coder
Fresh agent context; hand it the spec, not the conversation. It implements function by function — unit tests with each slice, suite run constantly. **Gate:** the project's unit-test command exits green, and each acceptance scenario maps to at least one test.

### Stage 3 — Cleaner
Run complexity/coverage tooling on the changed code; compute CRAP; refactor hotspots; then a review pass over the diff. **Gate:** cyclomatic complexity ≤ ~10 per function, lint clean, every review comment fixed or explicitly waived.

### Stage 4 — Hardener
Mutation-test the changed code. **Gate:** mutation score ≥ ~80%, every surviving mutant either killed by a stronger test or justified. Manual fallback: invert branches/boundaries in the diff one at a time and confirm a named test fails.

### Stage 5 — QA
Execute the QA script end to end against the assembled app (instrumented/UI tests where they exist; manual with recorded observations otherwise). **Gate:** every step passes. Any failure goes back to Stage 2 — with a failing scenario added to the spec *first*.

### Standing rules while it runs
- Disagreement = run the test. Never re-argue from the chat transcript.
- One stage, one context. Dispatch stages as fresh subagents with short artifact-focused prompts.
- Architecture is proposed by the agent, decided by you. Tactical is cheap; strategic is the leverage that stays human.

## 6. Deliverable per feature

```
specs/<feature>.feature      # Gherkin acceptance tests (the contract)
specs/<feature>.qa.md        # QA procedure + Stage 5 results
src/...                      # implementation
test/...                     # unit tests (Stage 2 gate evidence)
docs/reports/<feature>.md    # gate evidence: test run, complexity/CRAP, mutation score, QA result
```
