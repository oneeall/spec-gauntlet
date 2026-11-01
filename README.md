# Spec Gauntlet — Uncle Bob's agent workflow, operationalized

Digest of "LIVE: Uncle Bob on Software Fundamentals in the Age of AI" (Matt Pocock, 56:40) and the development workflow distilled from it, packaged as an installable [ZCode](https://zcode.ai) skill you can use day to day.

**The thesis:** AI agents raise the bar for engineering fundamentals, they don't lower it. When an agent can generate a plausible implementation in seconds, the scarce skill is no longer typing code — it is *judging* it: knowing what a good test suite proves, what a healthy module boundary looks like, and when a design will collapse under change. The discipline from *Clean Code* doesn't become obsolete; it becomes the specification layer that humans contribute.

## The workflow in one screen

```
requirement ──▶ 1 SPEC WRITER ──gate: executable Gherkin + QA script, human confirms
                     │
                     ▼ 2 CODER ────────gate: unit tests green
                     │
                     ▼ 3 CLEANER ──────gate: complexity capped (CRAP), review resolved
                     │
                     ▼ 4 HARDENER ─────gate: mutation tests killed (suite proves itself)
                     │
                     ▼ 5 QA ───────────gate: end-to-end pass on the assembled system
```

Humans write the specs and judge the design; agents write the code; every stage is closed by a deterministic, machine-checkable gate — never by hoping the model followed a long instruction.

## Install

```bash
git clone <this-repo> && cd uncle-bob-ai
./install.sh
```

`install.sh` symlinks the skill into `~/.zcode/skills/` (falling back to a copy), where ZCode discovers it in every project. To uninstall: `rm ~/.zcode/skills/spec-gauntlet`.

The skill also works from the repo itself: agents that honor the cross-tool `.agents/skills/` convention pick it up automatically when you work inside this repo. Trigger it by asking for any feature ("add a login screen", "build a CSV exporter"), by saying "use the gauntlet" / "uncle bob workflow", or explicitly with `/spec-gauntlet`.

## Repo layout

```
.agents/skills/spec-gauntlet/
├── SKILL.md                  # the five-stage pipeline — read this first
└── references/
    ├── gates.md              # gate tooling per platform (JVM/Android, JS/TS, Go, Rust, Python)
    └── templates.md          # Gherkin, QA script, ephemeral stage dispatch prompts
docs/
├── gauntlet-workflow.md      # full study digest (vocabulary, timestamps, Q&A positions)
└── templates/                # copyable spec + QA templates for each feature
install.sh
```

## The five working rules (from the episode's close)

1. **Write specifications, not steering prompts.** Freeze intent into Gherkin acceptance tests; the spec, not the prompt, is the contract.
2. **Prefer deterministic gates over longer instructions.** Every stage ends in a machine-checkable result — green tests, capped complexity, killed mutants.
3. **Keep agents ephemeral and single-purpose.** One clean context per task beats one bloated context per project.
4. **Spend human time on strategy.** Tactical work is cheap to delegate; architecture and system design are the leverage that stays human.
5. **Treat fundamentals as the job description.** Doing the agent's work manually under strict deterministic constraints is the training path for judgment.

## Attribution

The workflow and rules come from Robert C. Martin ("Uncle Bob") in conversation with Matt Pocock — [youtube.com/watch?v=zcLPGC-tvgk](https://youtube.com/watch?v=zcLPGC-tvgk). This repo is an independent operationalization of those ideas; see [docs/gauntlet-workflow.md](docs/gauntlet-workflow.md) for the full digest with timestamps.
