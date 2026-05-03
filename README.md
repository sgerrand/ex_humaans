# Humaans

[![Build Status](https://github.com/sgerrand/ex_humaans/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/sgerrand/ex_humaans/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/sgerrand/ex_humaans/badge.svg?branch=main)](https://coveralls.io/github/sgerrand/ex_humaans?branch=main)
[![Hex Version](https://img.shields.io/hexpm/v/humaans.svg)](https://hex.pm/packages/humaans)
[![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/humaans/)

An Elixir client for the [Humaans API][humaans-api-docs].

## Installation

The package can be installed by adding `humaans` to your list of dependencies in
`mix.exs`:

<!-- x-release-please-start-version -->
```elixir
def deps do
  [
    {:humaans, "~> 0.5.1"}
  ]
end
```
<!-- x-release-please-end -->

## Usage

To use this client with the Humaans API, you'll need to generate an API access token in the Humaans application.

### Client-based approach

The recommended way to use this library is to instantiate a client first:

```elixir
# Create a client with your access token
client = Humaans.new(access_token: "YOUR_ACCESS_TOKEN")

# Make API requests passing the client as the first argument
{:ok, people} = Humaans.People.list(client)
{:ok, person} = Humaans.People.retrieve(client, "person_id")
{:ok, company} = Humaans.Companies.retrieve(client, "company_id")
```

This approach allows you to create multiple clients with different access tokens and use them independently.

### Tuning the HTTP client

Pass `:req_options` to `Humaans.new/1` to customise the underlying [Req][req] client (timeouts, retries, plugins, etc.):

```elixir
client =
  Humaans.new(
    access_token: "YOUR_ACCESS_TOKEN",
    req_options: [connect_options: [timeout: 30_000], retry: :transient]
  )
```

For deeper customisation, implement `Humaans.HTTPClient.Behaviour` and pass the module via `:http_client`.

[req]: https://hexdocs.pm/req/

### Module access helpers

The library provides convenience functions to access the different resource modules:

```elixir
client = Humaans.new(access_token: "YOUR_ACCESS_TOKEN")

# Use the module access helpers
{:ok, people} = Humaans.people().list(client)
{:ok, accounts} = Humaans.bank_accounts().list(client)
{:ok, companies} = Humaans.companies().list(client)
```

### Available resources

- `Humaans.People` - Work with people resources
- `Humaans.BankAccounts` - Work with bank account resources
- `Humaans.Companies` - Work with company resources
- `Humaans.CompensationTypes` - Work with compensation type resources
- `Humaans.Compensations` - Work with compensation resources
- `Humaans.TimesheetEntries` - Work with timesheet entry resources
- `Humaans.TimesheetSubmissions` - Work with timesheet submission resources

## Development

### Requirements

- Elixir ~> 1.15
- [Homebrew](https://brew.sh) (for installing development tools)

### Setup

Run the setup script to install development tools and git hooks:

```shell
bin/setup
```

This installs `actionlint`, `check-jsonschema`, `lefthook`, and `markdownlint-cli2` via Homebrew, then configures the pre-commit hooks.

### Commands

| Command | Description |
| --- | --- |
| `mix setup` | Install dependencies |
| `mix test` | Run the test suite |
| `mix credo` | Run the linter |
| `mix format` | Format source files |

## License

Humaans is [released under the MIT license](LICENSE).

[humaans-api-docs]: https://docs.humaans.io/api/
