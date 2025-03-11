defmodule Humaans.Client do
  @moduledoc """
  Internal module for making HTTP requests to the Humaans API.

  This module provides a consistent interface for all HTTP operations used by the
  resource modules. It handles:

  * Constructing proper URLs
  * Setting up appropriate headers
  * Selecting the right HTTP method
  * Processing request parameters
  * Delegating to the configured HTTP client

  ## Architecture

  The client module sits between resource modules (like `Humaans.People`) and the
  actual HTTP client implementation (like `Humaans.HTTPClient.Req`):

  ```
  Resource Modules (People, Companies, etc.)
         │
         ▼
    Humaans.Client
         │
         ▼
  HTTP Client Implementation
  ```

  This layered approach allows:
  1. Resource modules to focus on their specific API operations
  2. HTTP client implementations to focus on HTTP communication details
  3. This module to provide a consistent interface between them

  ## Internal Use

  This module is primarily meant for internal use by other modules in the library.
  End users should interact with the resource modules instead.
  """

  @typep response :: {:ok, map()} | {:error, map()}

  @spec delete(client :: map(), path :: String.t()) :: response()
  def delete(client, path) do
    request(:delete, path, client, [])
  end

  @spec get(client :: map(), path :: String.t()) :: response()
  def get(client, path) do
    request(:get, path, client, [])
  end

  @spec get(client :: map(), path :: String.t(), params :: keyword()) :: response()
  def get(client, path, params) do
    request(:get, path, client, params: params)
  end

  @spec post(client :: map(), path :: String.t(), params :: keyword()) :: response()
  def post(client, path, params \\ []) do
    request(:post, path, client, body: params)
  end

  @spec patch(client :: map(), path :: String.t(), params :: keyword()) :: response()
  def patch(client, path, params \\ []) do
    request(:patch, path, client, body: params)
  end

  defp build_headers, do: [{"Accept", "application/json"}]

  defp build_url(client, path), do: "#{client.base_url}#{path}"

  defp request(method, path, client, opts) do
    headers = build_headers()
    url = build_url(client, path)
    opts = Keyword.merge([headers: headers, method: method, url: url], opts)

    client.http_client.request(client, opts)
  end
end
