# TDD Skills Plugins

Claude Code plugin collection for TDD workflow.

## Plugins

| Plugin | Description |
|--------|-------------|
| tdd-core | TDD 7-phase workflow (INIT → PLAN → RED → GREEN → REFACTOR → REVIEW → COMMIT) |
| tdd-php | PHP quality tools (PHPStan, Pint, PHPUnit/Pest) |
| tdd-python | Python quality tools (pytest, mypy, Black/isort) |

## Installation

```bash
# Core TDD workflow
/plugin install tdd-core@tdd-skills

# PHP development
/plugin install tdd-php@tdd-skills

# Python development
/plugin install tdd-python@tdd-skills
```

## Recommended Combinations

```bash
# PHP project
/plugin install tdd-core@tdd-skills
/plugin install tdd-php@tdd-skills

# Python project
/plugin install tdd-core@tdd-skills
/plugin install tdd-python@tdd-skills
```

## Development

Test plugin structure:

```bash
bash scripts/test-plugins-structure.sh
```
