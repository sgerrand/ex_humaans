# Humaans

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

To use this client with the Humaans API, you'll need to complete the following steps:
1. Generate an API access token in Humaans.
2. Add this access token to your application configuration (e.g. in
   `config/config.exs`) as follows:
   ```elixir
   config :humaans, access_token: "REPLACE_THIS_WITH_YOUR_ACCESS_TOKEN"
   ```

### Example

Once you have configured your instance of Humaans, you're ready to start making
requests:

```elixir
{:ok, people} = Humaans.People.list()
```

## License

Humaans is [released under the MIT license](LICENSE).

[humaans-api-docs]: https://docs.humaans.io/api/
