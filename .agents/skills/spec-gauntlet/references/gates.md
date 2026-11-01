# Gate tooling per platform

Pick the project's stack, use the first available tool in each row, and wire the command into the stage gate. If nothing listed is installed, ask the user before installing — and remember the gate must still be objective: a raw number, a score, or an exit code.

## CRAP score

```
CRAP(function) = cyclomatic_complexity² × (1 − coverage)³ + cyclomatic_complexity
```

Interpretation: high complexity with weak coverage scores worst — that is exactly where refactoring pays. Complexity ≤ 10 with good coverage yields CRAP ≈ complexity, i.e. low risk. Treat CRAP ≥ 30 on changed code as a refactor target.

## Stage gates by platform

| Gate | JVM / Android | JS / TS | Go | Rust | Python |
|---|---|---|---|---|---|
| Unit tests (Stage 2) | `./gradlew test` (JUnit); `testDebugUnitTest` for Android modules | `npm test` / `vitest` / `jest` | `go test ./...` | `cargo test` | `pytest` |
| Complexity / lint (Stage 3) | detekt (+ `detektMetrics`/complexity report), ktlint for style; JaCoCo for coverage | ESLint (`complexity` rule), `typhonjs-escomplex` | `golangci-lint` (gocyclo / cyclop) | Clippy, `cargo modules` | `radon cc`, Ruff |
| Mutation testing (Stage 4) | PIT via the `pitest` Gradle plugin (JVM unit tests; for Android apply to pure-JVM modules or extract domain logic from android modules) | Stryker (`@stryker-mutator/core`) | `go-mutesting` or `gremlins` | `cargo-mutants` | `mutmut` |
| End-to-end (Stage 5) | `./gradlew connectedAndroidTest` (Espresso / Compose UI Test); Compose Preview + manual QA script otherwise | Playwright / Cypress | Playwright (via JS harness) or API-level e2e | API-level e2e / `cargo test --ignored` | Playwright / pytest + API tests |

## Android notes

- Keep the gauntlet's Stage 2–4 gates inside pure-JVM modules (`:core:domain`, `:feature:x`) so PIT and JaCoCo work cleanly; use instrumented tests only for the Stage 5 gate.
- The `android` Gradle plugin blocks PIT; move testable logic out of `com.android.*` modules or run PIT only on Kotlin JVM library modules.
- Compose UI: one Compose UI Test per Gherkin scenario for Stage 5 beats a brittle Espresso script.

## Manual fallbacks (when tooling can't be installed)

- Stage 3: `radon`-style manual review — list every function in the diff, count branch points (`if/when/&&/||/for/catch`) + 1, flag > 10.
- Stage 4: pick the 5 riskiest functions in the diff; for each, manually invert one operator/boundary at a time and confirm a named test fails. Write the missing test for any silent mutant.
- Always record what was measured and how in the stage report, so the gate stays honest.
