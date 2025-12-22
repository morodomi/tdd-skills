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
| tdd-review | Quality checks (test, lint, coverage) |
| tdd-commit | Git commit |

## Workflow

```
INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT
```

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
