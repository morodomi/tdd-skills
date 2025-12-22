# tdd-js

JavaScript quality tools for TDD workflow with Claude Code.

## Installation

```bash
/plugin install tdd-js@tdd-skills
```

## Skills

| Skill | Description |
|-------|-------------|
| js-quality | JavaScript quality checks (ESLint, Prettier, Jest/Vitest) |

## Tools

| Tool | Command |
|------|---------|
| ESLint | `npx eslint .` |
| Prettier | `npx prettier --check .` |
| Jest | `npx jest` |
| Vitest | `npx vitest run` |

## Usage with Core Plugin

Combine with tdd-core for full TDD workflow:

```bash
/plugin install tdd-core@tdd-skills
/plugin install tdd-js@tdd-skills
```
