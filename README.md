# Humaans

[![Hex Version](https://img.shields.io/hexpm/v/humaans.svg)](https://hex.pm/packages/humaans) [![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/humaans/)

An Elixir client for the [Humaans API][humaans-api-docs].

## Installation

The package can be installed by adding `humaans` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:humaans, "~> 0.1.0"}
  ]
end
```

## Usage

To use this client with the Humaans API, you'll need to generate an API access token in the Humaans application.

### Client-based approach (recommended)

The recommended way to use this library is with the client-based approach:

```elixir
# Create a client with your access token
client = Humaans.new(access_token: "YOUR_ACCESS_TOKEN")

# Make API requests passing the client as the first argument
{:ok, people} = Humaans.People.list(client)
{:ok, person} = Humaans.People.retrieve(client, "person_id")
{:ok, company} = Humaans.Companies.retrieve(client, "company_id")
```

This approach allows you to create multiple clients with different access tokens and use them independently.

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

## License

Humaans is [released under the MIT license](LICENSE).

[humaans-api-docs]: https://docs.humaans.io/api/
