# tdd-laravel

Laravel-specific quality tools for TDD workflow with Claude Code.

## Installation

```bash
/plugin install tdd-laravel@tdd-skills
```

## Requirements

- PHP 8.1+
- Laravel 10.x / 11.x
- Pest 2.x with Laravel Plugin

## Skills

| Skill | Description |
|-------|-------------|
| laravel-quality | Laravel quality checks (Larastan, Pest, Pint) |

## Tools

| Tool | Command |
|------|---------|
| Pest | `php artisan test` |
| PHPStan | `./vendor/bin/phpstan analyse` (Larastan) |
| Pint | `./vendor/bin/pint` |

## Laravel-specific Features

- **Pest Laravel helpers** (actingAs, assertDatabaseHas, etc.)
- **Feature vs Unit** test guidelines
- **HTTP/Database** test patterns
- **Facade Mocking** (Mail, Queue, Event)

## Usage with Core Plugin

```bash
/plugin install tdd-core@tdd-skills
/plugin install tdd-laravel@tdd-skills
```

See `laravel-quality` skill for detailed usage and examples.

For generic PHP tools, see `tdd-php` plugin.
