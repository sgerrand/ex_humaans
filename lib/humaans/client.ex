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

  @typedoc """
  Standard response format from HTTP operations.

  * `{:ok, map()}` - Successful response with decoded response body
  * `{:error, map()}` - Error response with error details
  """
  @type response :: {:ok, map()} | {:error, map()}

  @doc """
  Makes a DELETE request to the specified path.

  Used for deleting resources from the Humaans API.

  ## Parameters

  * `client` - The Humaans client struct
  * `path` - API endpoint path (e.g., "/people/123")

  ## Returns

  * `{:ok, response}` - Successful deletion response
  * `{:error, reason}` - Error response
  """
  @spec delete(client :: map(), path :: String.t()) :: response()
  def delete(client, path) do
    request(:delete, path, client, [])
  end

  @doc """
  Makes a GET request to the specified path.

  Used for retrieving resources from the Humaans API.

  ## Parameters

  * `client` - The Humaans client struct
  * `path` - API endpoint path (e.g., "/people/123")

  ## Returns

  * `{:ok, response}` - Successful response with retrieved data
  * `{:error, reason}` - Error response
  """
  @spec get(client :: map(), path :: String.t()) :: response()
  def get(client, path) do
    request(:get, path, client, [])
  end

  @doc """
  Makes a GET request with query parameters.

  Used for retrieving resources with filtering, pagination, or other query parameters.

  ## Parameters

  * `client` - The Humaans client struct
  * `path` - API endpoint path (e.g., "/people")
  * `params` - Query parameters as keyword list (e.g., [limit: 10, skip: 20])

  ## Returns

  * `{:ok, response}` - Successful response with retrieved data
  * `{:error, reason}` - Error response
  """
  @spec get(client :: map(), path :: String.t(), params :: keyword()) :: response()
  def get(client, path, params) do
    request(:get, path, client, params: params)
  end

  @doc """
  Makes a POST request to create a new resource.

  Used for creating new resources in the Humaans API.

  ## Parameters

  * `client` - The Humaans client struct
  * `path` - API endpoint path (e.g., "/people")
  * `params` - Request body parameters (optional, defaults to empty list)

  ## Returns

  * `{:ok, response}` - Successful response with created resource data
  * `{:error, reason}` - Error response
  """
  @spec post(client :: map(), path :: String.t(), params :: keyword()) :: response()
  def post(client, path, params \\ []) do
    request(:post, path, client, body: params)
  end

  @doc """
  Makes a PATCH request to update an existing resource.

  Used for updating resources in the Humaans API.

  ## Parameters

  * `client` - The Humaans client struct
  * `path` - API endpoint path (e.g., "/people/123")
  * `params` - Request body parameters with fields to update (optional, defaults to empty list)

  ## Returns

  * `{:ok, response}` - Successful response with updated resource data
  * `{:error, reason}` - Error response
  """
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
