defmodule Humaans do
  @moduledoc """
  A HTTP client for the Humaans API.

  [Humaans API Docs](https://docs.humaans.io/api/)
  """

  @base_url "https://app.humaans.io/api"

  @doc """
  Creates a new client with the given base URL and API key.
  """
  @spec new(access_token :: String.t()) :: map()
  def new(access_token) do
    Req.new(
      base_url: @base_url,
      auth: {:bearer, access_token},
      headers: [{"Accept", "application/json"}]
    )
  end
end
