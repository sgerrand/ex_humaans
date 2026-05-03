defmodule Humaans do
  @moduledoc """
  A HTTP client for the Humaans API.

  This library provides an interface to the Humaans API, allowing you to manage
  people, companies, bank accounts, compensations, timesheet entries, and more.
  It follows a modular design where the main `Humaans` module serves as the
  entry point for creating clients, while specific resource modules handle
  operations for each resource type.

  [Humaans API Documentation](https://docs.humaans.io/api/)

  ## Architecture

  The library follows a layered architecture:
  - `Humaans` - Main module that creates configured client instances
  - Resource modules (`People`, `Companies`, etc.) - Handle operations specific to each resource type
  - HTTP client - Abstracts the HTTP communication details in a configurable manner

  ## Configuration Options

  When creating a client with `Humaans.new/1`, you can configure:

  * `:access_token` - Your Humaans API access token (required)
  * `:base_url` - The base URL for API requests (defaults to "https://app.humaans.io/api")
  * `:http_client` - The HTTP client module to use (defaults to `Humaans.HTTPClient.Req`)
  * `:req_options` - Keyword list merged into the default `Req` client config
    (e.g. `[connect_options: [timeout: 30_000], retry: :transient]`). Has no
    effect when `:http_client` is overridden.

  ## Examples

      # Create a default client
      client = Humaans.new(access_token: "some-access-token")

      # Create a client with custom base URL
      client = Humaans.new(
        access_token: "some-access-token",
        base_url: "https://custom-instance.humaans.io/api"
      )

      # Create a client with custom HTTP client
      client = Humaans.new(
        access_token: "some-access-token",
        http_client: MyCustomHTTPClient
      )

      # Tune timeouts and retries on the default Req client
      client = Humaans.new(
        access_token: "some-access-token",
        req_options: [connect_options: [timeout: 30_000], retry: :transient]
      )

      # Make API calls
      {:ok, people} = Humaans.People.list(client)
      {:ok, person} = Humaans.People.retrieve(client, "123")
      {:ok, companies} = Humaans.Companies.list(client)

      # Create a new person
      person_params = %{
        "firstName" => "Jane",
        "lastName" => "Doe",
        "email" => "jane.doe@example.com"
      }
      {:ok, new_person} = Humaans.People.create(client, person_params)

  ## Telemetry

  This library emits [`:telemetry`](https://hexdocs.pm/telemetry) events for all
  API requests. See `Humaans.Telemetry` for the full list of events, measurements,
  and metadata.

  ## Pagination

  Use `Humaans.Pagination` to iterate through large result sets without loading
  everything into memory:

      # Stream all people 50 at a time
      client
      |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 50)
      |> Enum.each(fn person -> IO.puts(person.first_name) end)

      # Fetch a specific page
      {:ok, result} = Humaans.Pagination.page(client, &Humaans.People.list/2, 2, page_size: 25)
  """

  @type t :: %__MODULE__{
          access_token: String.t(),
          base_url: String.t(),
          http_client: module(),
          req_options: keyword()
        }

  @enforce_keys [:access_token, :base_url, :http_client]
  defstruct [:access_token, :base_url, :http_client, req_options: []]

  @base_url "https://app.humaans.io/api"

  @doc """
  Creates a new client with the given access token and optional parameters.

  ## Options
    * `:access_token` - The access token to use for authentication (required)
    * `:base_url` - The base URL for API requests (defaults to #{@base_url})
    * `:http_client` - HTTP client module (defaults to `Humaans.HTTPClient.Req`)
    * `:req_options` - Keyword list merged into the default `Req` client
      config. Ignored when `:http_client` is overridden.

  ## Examples
      iex> client = Humaans.new(access_token: "some-access-token")
      iex> is_map(client)
      true
  """
  @spec new(opts :: keyword()) :: map()
  def new(opts) when is_list(opts) do
    access_token = Keyword.fetch!(opts, :access_token)
    base_url = Keyword.get(opts, :base_url, @base_url)
    http_client = Keyword.get(opts, :http_client, Humaans.HTTPClient.Req)
    req_options = Keyword.get(opts, :req_options, [])

    struct!(__MODULE__,
      access_token: access_token,
      base_url: base_url,
      http_client: http_client,
      req_options: req_options
    )
  end

  @doc """
  Access the People API.

  Returns the module that contains functions for working with people resources.
  """
  def people, do: Humaans.People

  @doc """
  Access the Bank Accounts API.

  Returns the module that contains functions for working with bank account resources.
  """
  def bank_accounts, do: Humaans.BankAccounts

  @doc """
  Access the Companies API.

  Returns the module that contains functions for working with company resources.
  """
  def companies, do: Humaans.Companies

  @doc """
  Access the Compensation Types API.

  Returns the module that contains functions for working with compensation type resources.
  """
  def compensation_types, do: Humaans.CompensationTypes

  @doc """
  Access the Compensations API.

  Returns the module that contains functions for working with compensation resources.
  """
  def compensations, do: Humaans.Compensations

  @doc """
  Access the Timesheet Entries API.

  Returns the module that contains functions for working with timesheet entry resources.
  """
  def timesheet_entries, do: Humaans.TimesheetEntries

  @doc """
  Access the Timesheet Submissions API.

  Returns the module that contains functions for working with timesheet submission resources.
  """
  def timesheet_submissions, do: Humaans.TimesheetSubmissions

  @doc """
  Access pagination helpers.

  Returns `Humaans.Pagination`, which provides `page/4` for fetching a specific
  page and `stream/3` for lazily iterating all results.
  """
  def pagination, do: Humaans.Pagination
end
