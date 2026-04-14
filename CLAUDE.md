# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development

### Requirements

- Elixir ~> 1.15
- Homebrew (for development tools: `actionlint`, `check-jsonschema`, `lefthook`, `markdownlint-cli2`)

### Setup

```shell
bin/setup   # installs dev tools via Homebrew and configures git hooks (lefthook)
mix setup   # installs Elixir dependencies
```

### Commands

- Run all tests: `mix test`
- Run single test: `mix test path/to/test_file.exs:line_number`
- Lint: `mix credo`
- Format: `mix format`

## Architecture

`ex_humaans` is an Elixir HTTP client library for the [Humaans](https://humaans.io) HR API.

### Request flow

```text
Humaans.new/1
  → resource module (People, Companies, etc.)
    → Humaans.Client (builds URL + headers)
      → Humaans.HTTPClient.Behaviour impl (default: Humaans.HTTPClient.Req)
        → Req library
          → Humaans.ResponseHandler (parses response, returns struct or error)
```

### Key patterns

**Client creation** — `Humaans.new(access_token: "...", http_client: MyClient)`. The `:http_client` field allows injecting a custom implementation of `Humaans.HTTPClient.Behaviour` (used in tests via `Humaans.MockHTTPClient`).

**Resource modules** — Each resource (`People`, `Companies`, `BankAccounts`, `Compensations`, `CompensationTypes`, `TimesheetEntries`, `TimesheetSubmissions`) exposes whichever of `list/2`, `create/2`, `retrieve/2`, `update/3`, `delete/2` the API supports. All return `{:ok, struct}` or `{:error, reason}`.

**Resource structs** — Live in `lib/humaans/resources/`. Use `ExConstructor` for automatic camelCase→snake_case JSON mapping. `Humaans.Response` holds raw HTTP responses (`status`, `headers`, `body`).

**Response handling** — `Humaans.ResponseHandler` unwraps `{"data": [...]}` envelopes and converts payloads to typed structs.

### Testing

Tests mock the HTTP layer via `Mox`. Setup creates a client with `Humaans.MockHTTPClient`, sets expectations with `Mox.expect/3` to assert on request shape and return fixture data, then asserts on the returned structs.

## Git Flow

- Branch naming: `feature-description-ticket-id`
- PRs should include tests and documentation updates
