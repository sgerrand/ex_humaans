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
end
