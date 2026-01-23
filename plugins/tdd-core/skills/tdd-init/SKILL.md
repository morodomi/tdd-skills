---
name: tdd-init
description: Start a new TDD cycle and create a Cycle doc. Triggers on "new feature", "start TDD", "add feature".
---

# TDD INIT Phase

Start a new TDD cycle and create a Cycle doc.

## Progress Checklist

```
INIT: STATUS check → Environment → Existing cycle → Questions → Risk assessment → Scope → Feature name → Cycle doc → Guide to PLAN
```

## Restrictions

- No detailed implementation planning (done in PLAN)
- No test code (done in RED)
- No implementation code (done in GREEN)

## Workflow

### Step 1: Check Project Status

```bash
cat docs/STATUS.md 2>/dev/null
```

If not found, recommend `tdd-onboard`.

### Step 2: Collect Environment Info

Collect language versions and key packages for Cycle doc Environment section.
Details: [reference.md](reference.md)

### Step 3: Check Existing Cycles

```bash
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

If an active cycle exists, recommend continuing it.

### Step 4: Ask What to Implement

Ask "What feature do you want to implement?" e.g., login, CSV export.

### Step 4.5: Risk Score Assessment

Calculate risk score (0-100) from user input:

| Score | Result | Action |
|-------|--------|--------|
| 0-29 | PASS | Show confirmation, auto-proceed |
| 30-59 | WARN | Scope confirmation (Step 5) |
| 60-100 | BLOCK | Risk-type questions (Step 4.6) |

Keyword scores: [reference.md](reference.md)
Record `Risk: [score] ([result])` in Cycle doc.

### Step 4.6: Brainstorm & Risk Questions (BLOCK only)

**First, clarify the problem** (Brainstorm):
- What problem are you really trying to solve?
- Have you considered alternative approaches?

**Then, risk-type questions** based on detected keywords:

| Risk Type | Questions |
|-----------|-----------|
| Security | Auth method, target users, 2FA |
| External API | API auth, error handling, rate limiting |
| Data Changes | Existing data impact, rollback |

Templates: [reference.md](reference.md). Record in `Risk Interview` section.

### Step 5: Scope (Layer) Confirmation

Use AskUserQuestion to confirm scope:

| Layer | Description | Plugin |
|-------|-------------|--------|
| Backend | PHP/Python etc. | tdd-php, tdd-python, tdd-flask |
| Frontend | JavaScript/TypeScript | tdd-js, tdd-ts |
| Both | Full stack | Multiple plugins |

Details: [reference.md](reference.md)

### Step 6: Generate Feature Name & Create Cycle Doc

Generate feature name (3-5 words) and create Cycle doc from [templates/cycle.md](templates/cycle.md).

### Step 7: Complete & Guide to PLAN

Display `INIT Complete` and guide to PLAN phase.

## Reference

Details: [reference.md](reference.md) | Japanese: [reference.ja.md](reference.ja.md)
