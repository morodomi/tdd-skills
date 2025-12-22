# tdd-python

Python quality tools for TDD workflow with Claude Code.

## Installation

```bash
/plugin install tdd-python@tdd-skills
```

## Skills

| Skill | Description |
|-------|-------------|
| python-quality | Python quality checks (pytest, mypy, Black) |

## Tools

| Tool | Command |
|------|---------|
| pytest | `pytest` |
| mypy | `mypy --strict` |
| Black | `black .` |
| isort | `isort .` |
| ruff | `ruff check .` |

## Usage with Core Plugin

Combine with tdd-core for full TDD workflow:

```bash
/plugin install tdd-core@tdd-skills
/plugin install tdd-python@tdd-skills
```
