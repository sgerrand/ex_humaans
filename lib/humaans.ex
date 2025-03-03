defmodule Humaans do
  @moduledoc """
  A HTTP client for the Humaans API.

  [Humaans API Docs](https://docs.humaans.io/api/)

  ## Examples

      # Create a client
      client = Humaans.new(access_token: "some-access-token")

      # Make API calls
      {:ok, people} = Humaans.People.list(client)
      {:ok, person} = Humaans.People.retrieve(client, "123")
  """

  @base_url "https://app.humaans.io/api"

  @doc """
  Creates a new client with the given access token and optional parameters.

  ## Options
    * `:access_token` - The access token to use for authentication (required)
    * `:base_url` - The base URL for API requests (defaults to #{@base_url})

  ## Examples
      iex> client = Humaans.new(access_token: "some-access-token")
      iex> is_map(client)
      true
  """
  @spec new(opts :: keyword()) :: map()
  def new(opts) when is_list(opts) do
    access_token = Keyword.fetch!(opts, :access_token)
    base_url = Keyword.get(opts, :base_url, @base_url)

    %{
      req:
        Req.new(
          base_url: base_url,
          auth: {:bearer, access_token},
          headers: [{"Accept", "application/json"}]
        )
    }
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
end
