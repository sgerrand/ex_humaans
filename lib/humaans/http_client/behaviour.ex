defmodule Humaans.HTTPClient.Behaviour do
  @moduledoc """
  Behaviour for Humaans HTTP clients.

  This module defines the interface that all HTTP client implementations must follow.
  The library comes with a default implementation using the Req HTTP client
  (`Humaans.HTTPClient.Req`), but you can provide your own implementation by:

  1. Creating a module that implements this behaviour
  2. Passing your module to `Humaans.new/1` as the `:http_client` option

  ## Custom Client Implementation

  A custom HTTP client must implement the `request/2` callback, which handles
  all HTTP communication with the Humaans API. Your implementation should:

  - Apply proper authentication using the client's access token
  - Handle request and response encoding/decoding
  - Process errors appropriately
  - Return standardized response structures

  Example of a minimal custom implementation:

      defmodule MyCustomHTTPClient do
        @behaviour Humaans.HTTPClient.Behaviour

        @impl true
        def request(client, opts) do
          # Implement the HTTP request logic
          # Return {:ok, response} or {:error, reason}
        end
      end

      # Then use it with:
      client = Humaans.new(
        access_token: "token",
        http_client: MyCustomHTTPClient
      )
  """

  @doc """
  Makes an HTTP request to the Humaans API.

  ## Parameters

  - `client` - A Humaans client struct containing configuration
  - `opts` - Request options including:
    - `:method` - HTTP method (`:get`, `:post`, `:patch`, `:delete`, etc.)
    - `:url` - The path to request, which will be appended to the base URL
    - `:headers` - HTTP headers to include in the request
    - `:body` - Request body for POST/PATCH requests (optional)
    - `:params` - Query parameters for GET requests (optional)

  ## Returns

  - `{:ok, response}` - Successful response with parsed body
  - `{:error, reason}` - Error with reason
  """
  @callback request(client :: Humaans.t(), opts :: Keyword.t()) :: {:ok, map()} | {:error, any()}
end
