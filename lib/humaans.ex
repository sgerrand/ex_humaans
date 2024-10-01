defmodule Humaans do
  @moduledoc """
  A client for the Humaans API.
  """

  @base_url "https://app.humaans.io/api"

  @doc """
  Creates a new client with the given base URL and API key.
  """
  @spec new(api_key :: String.t()) :: map()
  def new(api_key) do
    Req.new(
      base_url: @base_url,
      auth: {:bearer, api_key},
      headers: [{"Accept", "application/json"}]
    )
  end
end
