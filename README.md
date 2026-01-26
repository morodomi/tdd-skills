# TDD Skills

Claude Code plugin for enforcing strict TDD workflows

> **v4.0.0**: RED & GREEN Parallelization - Parallel agents for both test creation and implementation phases

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

## TDD Philosophy (v4.0.0)

### Ticket-Based RED-GREEN-REFACTOR

Traditional TDD (Kent Beck) recommends "RED->GREEN->REFACTOR per test".
tdd-skills cycles RED->GREEN->REFACTOR per **ticket (Cycle)**.

```
Traditional: test1 -> impl1 -> refactor -> test2 -> impl2 -> refactor
tdd-skills:  [test1, test2, test3] -> [impl1, impl2, impl3] -> refactor
```

### Why Batch Approach?

| Aspect | Human | AI Agent |
|--------|-------|----------|
| Motivation | Want to see green quickly | Irrelevant |
| Debugging | Hard with many changes | Trackable via logs |
| Parallelization | Impossible | Multiple agents in parallel |
| Context | Forgotten | Maintained in Cycle doc |

### Parallel Execution (v3.3 & v4.0)

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

Reference: [Canon TDD - Kent Beck](https://tidyfirst.substack.com/p/canon-tdd)

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

## Links

- [Claude Code Skills](https://docs.anthropic.com/en/docs/claude-code/skills)
- [anthropics/skills](https://github.com/anthropics/skills)
