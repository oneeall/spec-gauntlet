# spec-gauntlet

A workflow for building features with AI coding agents, taken from Robert C. Martin's conversation with Matt Pocock about software fundamentals in the age of AI (link at the bottom).

Short version: agents type fast and judge badly. So the human writes the spec, and the machine checks the work. Before any code exists, the requirement gets frozen into Gherkin acceptance tests. From there the work moves through five stages, and each stage ends in a check that a tool runs. If the check fails, you fix it in that stage. You never steer the model with a longer prompt, and you never let a failed stage slide.

The stages:

1. **Spec Writer.** Turn the requirement into Gherkin acceptance tests plus a QA script. You read them and confirm they say what you meant. This is the only gate a human closes.
2. **Coder.** A fresh agent implements the spec function by function, writing unit tests as it goes. Gate: the test suite passes.
3. **Cleaner.** Check complexity and coverage on the new code. The CRAP score points at code that is both complex and weakly tested, so you know where to refactor. Gate: complexity under control, review comments resolved.
4. **Hardener.** Mutation testing. Inject small bugs on purpose and confirm the tests catch them. Gate: the mutants die.
5. **QA.** Run the QA script against the assembled app, end to end. Gate: every step passes.

Why not just tell the agent what to do in one long prompt? Two things from the talk. Models quietly ignore instructions buried in the middle of a long prompt, and a single long agent session drifts as junk piles up in its context. Small stages with hard checks beat one big conversation.

## Install

```
git clone https://github.com/oneeall/spec-gauntlet
cd spec-gauntlet
./install.sh
```

This links the skill into `~/.zcode/skills`, so ZCode finds it in every project. Remove it later with `rm ~/.zcode/skills/spec-gauntlet`.

The pipeline itself is plain instructions in `.agents/skills/spec-gauntlet/SKILL.md`, so people on other agents can follow it too.

## Using it

Just ask for a feature the normal way ("add a password reset screen"). The skill drafts the spec first and waits for your confirmation, then runs the remaining stages. You can also call it directly with `/spec-gauntlet`.

## What's in here

- `.agents/skills/spec-gauntlet/` — the skill. SKILL.md is the pipeline, `references/` has gate tooling per platform (JVM/Android, JS/TS, Go, Rust, Python) and the templates.
- `docs/gauntlet-workflow.md` — study notes on the talk, with timestamps.
- `docs/templates/` — spec and QA templates to copy for each feature.

## Rules worth remembering

- Write specs, not steering prompts.
- Every stage ends in something a machine can check.
- One clean agent context per task.
- Architecture decisions stay with people. Typing is cheap now.
- Doing the agent's job by hand, under strict rules, is how you learn to judge its work.

Source: [LIVE: Uncle Bob on Software Fundamentals in the Age of AI](https://youtube.com/watch?v=zcLPGC-tvgk), Matt Pocock, 56:40.
