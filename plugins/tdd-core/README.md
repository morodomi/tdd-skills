# tdd-core

Language-agnostic TDD workflow skills for Claude Code.

## Installation

```bash
/plugin install tdd-core@tdd-skills
```

## Skills

| Skill | Description |
|-------|-------------|
| tdd-init | Start new TDD cycle, create Cycle doc |
| tdd-plan | Design implementation plan |
| tdd-red | Write failing tests |
| tdd-green | Minimal implementation to pass tests |
| tdd-refactor | Improve code quality |
| tdd-review | Quality checks (test, lint, coverage, quality-gate) |
| tdd-commit | Git commit |
| quality-gate | 4-agent parallel code review with confidence scoring |
| plan-review | 3-agent parallel design review |

## Agents

Review agents for quality-gate and plan-review:

| Agent | Focus |
|-------|-------|
| correctness-reviewer | Logic errors, edge cases, exception handling |
| performance-reviewer | Algorithm efficiency, N+1, memory usage |
| security-reviewer | Input validation, auth, SQLi/XSS |
| guidelines-reviewer | Coding standards, naming conventions |
| scope-reviewer | Scope validity, file count |
| architecture-reviewer | Design consistency, patterns |
| risk-reviewer | Impact analysis, breaking changes |

## Workflow

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

## Confidence Scoring

quality-gate and plan-review use confidence scores:

| Score | Result | Action |
|-------|--------|--------|
| 80-100 | BLOCK | Must fix before proceeding |
| 50-79 | WARN | Warning, can continue |
| 0-49 | PASS | No issues |

## Usage with Language Plugins

Combine with language-specific plugins:

```bash
# PHP development
/plugin install tdd-core@tdd-skills
/plugin install tdd-php@tdd-skills

# Python development
/plugin install tdd-core@tdd-skills
/plugin install tdd-python@tdd-skills
```
