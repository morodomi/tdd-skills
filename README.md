# TDD Skills

Claude Code plugin for enforcing strict TDD workflows

> **v5.1.0**: PdM + Socrates Advisor - Devil's Advocate for critical review decisions

[Japanese](README.ja.md)

## Why?

When letting AI write code, these problems often occur:

- Tests aren't written unless explicitly requested
- Quality checks require manual execution
- Context is lost when sessions end

**tdd-skills** solves these by "enforcing" TDD on Claude Code.

## Getting Started

### 1. Install Plugin

```bash
claude

> /plugin marketplace add morodomi/tdd-skills
> /plugin install tdd-core@tdd-skills
> /plugin install tdd-php@tdd-skills  # Choose based on language
```

### 2. Project Setup

```bash
> TDD setup
# or "onboard"

# Automatically executes:
# - Framework detection
# - CLAUDE.md generation
# - docs/ structure creation
```

### 3. Start Development

```bash
> I want to add a login feature

# TDD cycle starts automatically:
# INIT -> PLAN -> RED -> GREEN -> REFACTOR -> REVIEW -> COMMIT
```

## Installation

```bash
# Register marketplace
/plugin marketplace add morodomi/tdd-skills

# Install TDD workflow
/plugin install tdd-core@tdd-skills

# Language-specific quality tools (choose based on project)
/plugin install tdd-php@tdd-skills       # PHP
/plugin install tdd-laravel@tdd-skills   # Laravel
/plugin install tdd-wordpress@tdd-skills # WordPress / Bedrock
/plugin install tdd-python@tdd-skills    # Python
/plugin install tdd-flask@tdd-skills     # Flask
/plugin install tdd-ts@tdd-skills        # TypeScript
/plugin install tdd-js@tdd-skills        # JavaScript
/plugin install tdd-hugo@tdd-skills      # Hugo SSG
/plugin install tdd-flutter@tdd-skills   # Flutter / Dart

# Multi-language projects (e.g., Laravel + Alpine.js)
/plugin install tdd-php@tdd-skills
/plugin install tdd-js@tdd-skills
```

## TDD Workflow

```
INIT -> PLAN -> RED -> GREEN -> REFACTOR -> REVIEW -> COMMIT
```

| Phase | Skill | Description |
|-------|-------|-------------|
| INIT | tdd-init | Create cycle document, scope confirmation |
| PLAN | tdd-plan | Design & planning |
| RED | tdd-red | Create failing tests (parallel) |
| GREEN | tdd-green | Minimal implementation (parallel) |
| REFACTOR | tdd-refactor | Code improvement |
| REVIEW | tdd-review | Quality check |
| COMMIT | tdd-commit | Git commit |

## Agent Teams Integration (v4.3.0)

When `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is enabled:

| Feature | Without Agent Teams | With Agent Teams |
|---------|-------------------|------------------|
| **quality-gate** | 6-agent parallel (subagent) | Debate mode (discuss & refute) |
| **tdd-diagnose** | Explore agent parallel investigation | Team debate investigation |
| **tdd-parallel** | Not available (sequential fallback) | Cross-layer parallel development |

### tdd-diagnose (Bug Investigation)

```
Bug report -> Hypothesis generation -> Parallel investigation -> Root cause
                                         |
                        Investigator 1: "Race condition in auth"
                        Investigator 2: "Cache invalidation issue"
                        Investigator 3: "DB connection timeout"
                                         |
                                    Debate & refute -> Root cause identified
```

### tdd-parallel (Cross-Layer Development)

```
INIT -> PLAN -> [tdd-parallel] -> REVIEW -> COMMIT
                     |
          Teammate A: Backend  (RED->GREEN->REFACTOR)
          Teammate B: Frontend (RED->GREEN->REFACTOR)
          Teammate C: Database (RED->GREEN->REFACTOR)
                     |
              Integration test -> All green
```

## PdM Delegation Model (v5.0)

Claude acts as a PdM (Product Manager), focusing on planning and decision-making while delegating implementation, testing, and review to specialist agents. This separates concerns and keeps the main context lightweight.

```
v4.3: Claude --- Read Skill --- Execute phases --- Some subagent parallelization

v5.0: Claude(PdM) --- Plan & Decide --- Delegate --- Autonomous judgment
                          |
                    +-----+-----+
                  architect  red/green  refactorer
```

### 3-Block Orchestration

| Block | Phases | Description |
|-------|--------|-------------|
| Planning | INIT -> PLAN -> plan-review | PdM plans, architect agent designs |
| Implementation | RED -> GREEN -> REFACTOR -> quality-gate | Worker agents implement & review |
| Finalization | COMMIT | PdM commits with full context |

### Specialist Agents

| Agent | Phase | Role |
|-------|-------|------|
| architect | PLAN | Design and test list creation via Skill(tdd-plan) |
| red-worker | RED | Test creation (parallel) |
| green-worker | GREEN | Minimal implementation (parallel) |
| refactorer | REFACTOR | Code quality improvement via Skill(tdd-refactor) |

### tdd-orchestrate

`tdd-orchestrate` is an internal skill that runs automatically when Agent Teams is enabled. Users do not invoke it directly; `tdd-init` routes to it. It manages the full TDD cycle as a PdM hub, delegating each phase to the appropriate specialist agent and making autonomous pass/warn/block decisions.

### Activation

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
claude
> I want to add a login feature  # tdd-init automatically uses PdM orchestration
```

Without this variable, all v4.3 workflows continue unchanged. No migration or configuration changes are needed to stay on v4.3 behavior.

### Socrates Advisor (v5.1)

When plan-review or quality-gate produces a WARN or BLOCK score, Socrates Advisor activates as a Devil's Advocate teammate. Socrates challenges the PdM's proposal with objections and alternatives, improving decision quality before human judgment.

```
plan-review / quality-gate
         |
    Score 50+ (WARN/BLOCK)
         |
    Socrates (Devil's Advocate)
         |
    Objections & Alternatives
         |
    PdM merges merit/demerit
         |
    Human decides: proceed / fix / abort
```

#### Socrates Protocol

| Score | Judgment | Action |
|-------|----------|--------|
| 0-49 | PASS | Auto-proceed (no Socrates) |
| 50-79 | WARN | Socrates Protocol -> Human decision |
| 80-100 | BLOCK | Socrates Protocol -> Human decision |

After Socrates review, the user responds with free-text input:

| Input | Meaning |
|-------|---------|
| proceed | Continue to next phase as-is |
| fix | Revise and re-run the current phase |
| abort | Cancel the cycle |

If Socrates is unresponsive or returns unparseable responses, the system falls back to v5.0 logic automatically (WARN: auto-proceed, BLOCK: auto-retry).

## Parallel Execution (v3.3 & v4.0)

```
Test List: TC-01, TC-02, TC-03, TC-04
  |
  v
RED Phase (v4.0):
  Worker 1: TC-01, TC-02 -> tests/AuthTest.php
  Worker 2: TC-03, TC-04 -> tests/UserTest.php
  |
  v
GREEN Phase (v3.3):
  Worker 1: TC-01, TC-02 -> src/Auth.php
  Worker 2: TC-03, TC-04 -> src/User.php
```

## Question-Driven TDD (v3.0.0)

Automatically generates appropriate questions based on risk score:

```
User input -> Risk assessment -> Question flow -> Improved design accuracy
```

### Risk Score

| Score | Result | Action |
|-------|--------|--------|
| 0-29 | PASS | Auto-proceed |
| 30-59 | WARN | Scope confirmation + Quick questions |
| 60-100 | BLOCK | Risk-type specific questions |

### Risk Types (BLOCK questions)

| Type | Keywords | Questions |
|------|----------|-----------|
| Security | auth, login, permission | Auth method, 2FA, target users |
| External API | API, webhook, payment | API auth, error handling, rate limiting |
| Data Changes | DB, migration | Existing data impact, rollback |

## Plugins

| Plugin | Target | Tools |
|--------|--------|-------|
| **tdd-core** | All languages | TDD 7-phase workflow |
| **tdd-php** | PHP | PHPStan, Pint, PHPUnit/Pest |
| **tdd-laravel** | Laravel | Larastan, Pint, Pest |
| **tdd-wordpress** | WordPress / Bedrock | phpstan-wordpress, WPCS, PHPUnit |
| **tdd-python** | Python | pytest, mypy, Black |
| **tdd-flask** | Flask | pytest-flask, mypy, Black |
| **tdd-ts** | TypeScript | tsc, ESLint, Jest/Vitest |
| **tdd-js** | JavaScript | ESLint, Prettier, Jest |
| **tdd-hugo** | Hugo SSG | hugo build, htmltest |
| **tdd-flutter** | Flutter / Dart | dart analyze, flutter test |

## Quality Standards

| Item | Target |
|------|--------|
| Coverage | 90%+ |
| Static analysis | 0 errors |

## Migration

### v5.0 -> v5.1.0

**New feature**: Socrates Devil's Advocate Advisor
- Socrates Advisor: persistent Devil's Advocate teammate for Agent Teams
- Activates during plan-review/quality-gate when score is WARN (50-79) or BLOCK (80-100)
- Free-text human input: proceed/fix/abort (max 2 retries for unclear input)
- Automatic v5.0 fallback when Socrates is unresponsive
- No breaking changes: only activates with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Without Agent Teams: v5.0 behavior is fully preserved

### v4.3 -> v5.0.0

**New feature**: PdM Delegation Model
- Claude acts as Product Manager, delegating to specialist agents (architect, refactorer)
- `tdd-orchestrate`: Internal orchestration skill for full-cycle autonomous management
- `tdd-init` automatically routes to PdM mode when Agent Teams is enabled
- No breaking changes: all features are opt-in via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Without the env var: existing v4.3 workflows continue unchanged, no action required
- To revert: unset the variable, no migration needed

### v4.2 -> v4.3.0

**New features**: Agent Teams Integration
- quality-gate: debate mode with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`
- tdd-diagnose: parallel bug investigation (auto-triggered from tdd-init on high-risk)
- tdd-parallel: cross-layer parallel development orchestrator
- No breaking changes, all features are additive

### v4.0 -> v4.2.0

**New features**: Auto Phase Transition, Multi-Perspective Review
- Automatic skill execution between TDD phases
- plan-review: 5-agent parallel review
- quality-gate: 6-agent parallel review (mandatory)

### v3.x -> v4.0.0

**New feature**: RED Parallelization
- Parallel test creation with red-worker agents
- No additional configuration required, automatically enabled

### v2.x -> v3.0.0

**New feature**: Question-Driven TDD (risk-based question flow)
- No additional configuration required, automatically enabled

### v1.x -> v2.0

See [Migration Guide](docs/MIGRATION.md).
**Main change**: `agent_docs/` -> `.claude/rules/`, `.claude/hooks/` structure

## Update

```bash
/plugin marketplace update tdd-skills
```

## Cross-Platform Compatibility

These skills can be used with AI coding tools other than Claude Code.

| CLI Tool | Compatibility | Notes |
|----------|---------------|-------|
| **Claude Code** | Native | `.claude/skills/` |
| **GitHub Copilot CLI** | Auto-detect | Auto-recognizes `.claude/skills/` |
| **OpenAI Codex CLI** | Compatible | Same SKILL.md format |
| **Gemini CLI** | Via Extensions | Convertible with tools |

## License

[MIT](LICENSE)

## Related Projects

- [redteam-skills](https://github.com/morodomi/redteam-skills) - Security audit automation plugins (Red Team)

## Links

- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
