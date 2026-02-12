# tdd-init Reference

Detailed information for SKILL.md. Refer only when needed.

## Risk Score Assessment Details

### Score Thresholds (unified with plan-review/quality-gate)

| Score | Result | Action |
|-------|--------|--------|
| 0-29 | PASS | Show confirmation, auto-proceed |
| 30-59 | WARN | Quick questions (Step 4.6), then Scope confirmation (Step 5) |
| 60-100 | BLOCK | Brainstorm & risk questions (Step 4.7) |

### Keyword Scores

| Category | Keywords | Score |
|----------|----------|-------|
| Security | login, auth, authorization, password, session, permission, token | +60 |
| External Dependency | API, external integration, payment, webhook, third-party | +60 |
| Data Impact | DB change, migration, schema, table creation | +60 |
| Scope Impact | refactoring, large-scale, system-wide, architecture | +40 |
| Limited | test addition, documentation, comment, README | +10 |
| UI Only | UI fix, color, text, typo, CSS, style | +10 |
| Default | None of the above | 0 |

### Assessment Logic

```
1. Partial match search user input against keywords
2. Same category: max 1 addition (no duplicates)
3. Different categories: sum up (max 100)
4. No match: default 0 (PASS)

Examples:
- "typo fix" = +10 → PASS
- "bug fix" = 0 → PASS (no keyword match)
- "refactoring" = +40 → WARN
- "auth feature" = +60 → BLOCK
- "auth + password" = +60 → BLOCK (same category)
- "auth + API" = +100 → BLOCK (different categories, capped)
```

### Multiple Risk Types

When multiple categories match, **execute all risk-type questions sequentially**.

```
Example: "Login feature with API integration and DB changes"
→ Security questions (auth method, 2FA, etc.)
→ External API questions (API auth, error handling, etc.)
→ Data change questions (existing data impact, rollback, etc.)
```

Record all answers in the Cycle doc.

### WARN Questions (30-59)

Ask 2 lightweight questions to confirm scope before proceeding. Results are NOT recorded in Cycle doc.

```yaml
questions:
  - question: "Have you considered alternative approaches?"
    header: "Alternatives"
    options:
      - label: "Yes, this is the best option"
        description: "Evaluated alternatives and chose this"
      - label: "No, but scope is small enough"
        description: "Low risk, proceed anyway"
      - label: "Want to discuss options"
        description: "Need more exploration"
    multiSelect: false
  - question: "Do you understand the impact scope?"
    header: "Impact"
    options:
      - label: "Yes, limited to specific files"
        description: "Clear boundaries, low risk"
      - label: "Yes, but touches multiple areas"
        description: "Broader scope, manageable"
      - label: "Not sure, need to investigate"
        description: "May need more analysis"
    multiSelect: false
```

**Purpose**: Quick sanity check for medium-risk changes without the full BLOCK interview.

### Brainstorm Questions (BLOCK: 60+)

Before diving into risk-type questions, clarify the core problem:

```yaml
questions:
  - question: "What problem are you really trying to solve?"
    header: "Problem"
    options:
      - label: "User request"
        description: "Users explicitly asked for this feature"
      - label: "Technical debt"
        description: "Existing code is causing issues"
      - label: "Business requirement"
        description: "Required for business goals"
      - label: "Performance issue"
        description: "Current system is too slow"
    multiSelect: false
  - question: "Have you considered alternative approaches?"
    header: "Alternatives"
    options:
      - label: "Yes, this is the best option"
        description: "Evaluated alternatives and chose this"
      - label: "No, need to explore more"
        description: "Want to discuss other options"
      - label: "Partial solution exists"
        description: "Can extend existing functionality"
    multiSelect: false
```

**Purpose**: Prevent over-engineering by ensuring the problem is well-understood before implementation.

Reference: [superpowers/brainstorming](https://github.com/obra/superpowers/blob/main/skills/brainstorming/SKILL.md)

### Risk-Type Questions (BLOCK: 60+)

Execute AskUserQuestion based on detected keywords:

#### Security (login, auth, permission, password)

```yaml
questions:
  - question: "Which authentication method will you use?"
    header: "Auth"
    options:
      - label: "Session"
        description: "Server-side session management"
      - label: "JWT"
        description: "Token-based authentication"
      - label: "OAuth"
        description: "External provider integration"
      - label: "Extend existing"
        description: "Extend current auth system"
    multiSelect: false
  - question: "Target users?"
    header: "Users"
    options:
      - label: "Regular users"
        description: "Standard end users"
      - label: "Admins"
        description: "Users with admin privileges"
      - label: "Both"
        description: "Separated by permission level"
    multiSelect: false
  - question: "Is 2FA (two-factor authentication) required?"
    header: "2FA"
    options:
      - label: "Required"
        description: "Implement from initial release"
      - label: "Not required"
        description: "Password only"
      - label: "Consider later"
        description: "Plan to add in future"
    multiSelect: false
```

#### External Integration (API, webhook, payment, third-party)

```yaml
questions:
  - question: "API authentication method?"
    header: "API Auth"
    options:
      - label: "API Key"
        description: "Static key authentication"
      - label: "OAuth2"
        description: "Token-based"
      - label: "Signed request"
        description: "HMAC signature, etc."
    multiSelect: false
  - question: "Error handling strategy?"
    header: "Errors"
    options:
      - label: "Retry"
        description: "Retry on failure"
      - label: "Fallback"
        description: "Switch to alternative"
      - label: "Immediate error"
        description: "Notify user"
    multiSelect: true  # Retry + fallback combination is common
  - question: "Rate limiting approach?"
    header: "Rate Limit"
    options:
      - label: "Queuing"
        description: "Manage requests in queue"
      - label: "Backoff"
        description: "Exponential backoff retry"
      - label: "Not needed"
        description: "Won't hit limits"
    multiSelect: false
```

#### Data Changes (DB, migration, schema)

```yaml
questions:
  - question: "Impact on existing data?"
    header: "Data Impact"
    options:
      - label: "No impact"
        description: "New tables/columns only"
      - label: "Data conversion needed"
        description: "Migrate existing data"
      - label: "Data deletion"
        description: "Delete/merge some data"
    multiSelect: false
  - question: "Rollback method?"
    header: "Rollback"
    options:
      - label: "Auto rollback"
        description: "Down migration supported"
      - label: "Manual recovery"
        description: "Restore from backup"
      - label: "Forward compatible"
        description: "Works with old and new"
    multiSelect: false
```

### Recording Format in Cycle Doc

```markdown
## Environment

### Scope
- Layer: Backend
- Plugin: tdd-php
- Risk: 65 (BLOCK)  # ← Score format

### Risk Details (BLOCK only)
- Detected keywords: auth, API
- Total score: 65 (auth +60, no duplicates)
- Impact scope: 3-5 files
- External dependency: DB changes
```

## Hooks Check

In Step 1, after checking STATUS.md, verify hooks setup:

```bash
# Check if user has hooks configured
grep -q '"hooks"' ~/.claude/settings.json 2>/dev/null
```

**If hooks are not configured**, show recommendation:

```
Recommended hooks are available at .claude/hooks/recommended.md.
Copy the configuration to ~/.claude/settings.json for:
- --no-verify / rm -rf block
- Test file update reminders
- CLAUDE.md existence check
- Uncommitted changes warning
- Debug statement detection
```

**Do not auto-write to settings.json** (user must opt-in manually).

## Detailed Workflow

### Checking Existing Cycles

```bash
# Find latest Cycle doc
ls -t docs/cycles/*.md 2>/dev/null | head -1
```

**If an active cycle exists**:

```
⚠️ An existing TDD cycle is in progress.

Latest: docs/cycles/20251028_1530_XXX.md

Options:
1. [Recommended] Continue existing cycle
2. Start new cycle (parallel development)

What would you like to do?
```

### Scope (Layer) Confirmation Details

Use AskUserQuestion:

```
Select the scope for this feature:
1. Backend (PHP/Python server-side)
2. Frontend (JavaScript/TypeScript client-side)
3. Both (Full stack)
```

**Plugin Mapping:**

| Layer | Framework | Plugin |
|-------|-----------|--------|
| Backend | Laravel | tdd-php |
| Backend | Flask | tdd-flask |
| Backend | Django | tdd-python |
| Backend | WordPress | tdd-php |
| Backend | Generic PHP | tdd-php |
| Backend | Generic Python | tdd-python |
| Frontend | JavaScript | tdd-js |
| Frontend | TypeScript | tdd-ts |
| Frontend | Alpine.js | tdd-js |
| Both | Laravel + JS | tdd-php, tdd-js |

**Recording in Cycle doc:**

```markdown
## Environment

### Scope
- Layer: Backend
- Plugin: tdd-php
```

### Feature Name Generation

**Guidelines**:
- 3-5 words
- Descriptive suffix like "feature", "implementation"

**Examples**:
| What you want to do | Feature name |
|--------------------|--------------|
| Allow users to log in | User login feature |
| Export data as CSV | CSV export feature |
| Add search functionality | Search implementation |
| Send password reset emails | Password reset feature |

**If unclear**:

```
Please be more specific about the feature name.

Good examples: User authentication, Data search
Bad examples: Feature, New thing, That one
```

## Error Handling

### Not a Git Repository

```
⚠️ This directory is not a Git repository.

Git operations are required at the end of TDD cycle.
Recommend using within a Git repository.

Continue anyway?
```

### Directory Creation Failed

```
Error: Failed to create docs/cycles directory.

Solutions:
1. Check permissions: ls -la ./
2. Create manually: mkdir -p docs/cycles
```

## Project-Specific Customization

### Additional Validations

```bash
# Node.js
if [ ! -f "package.json" ]; then
  echo "Warning: package.json not found"
fi

# Python
if [ ! -f "requirements.txt" ]; then
  echo "Warning: requirements.txt not found"
fi
```

### Extending Cycle Doc Template

Add project-specific sections to `templates/cycle.md`.
