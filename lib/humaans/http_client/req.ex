defmodule Humaans.HTTPClient.Req do
  @moduledoc """
  Default HTTP client implementation using `Req`.

  This module is used by default when you create a new Humaans client without
  specifying a custom HTTP client.

  ## Customization

  For most tweaks (timeouts, retries, plugins), pass `:req_options` directly
  to `Humaans.new/1`. They are merged into the Req client config:

      Humaans.new(
        access_token: "...",
        req_options: [connect_options: [timeout: 30_000], retry: :transient]
      )

  If you need to wrap or replace the entire request pipeline, implement your
  own module satisfying `Humaans.HTTPClient.Behaviour` and pass it via
  `:http_client`:

  ```elixir
  defmodule MyCustomReqClient do
    @behaviour Humaans.HTTPClient.Behaviour

    @impl true
    def request(client, opts) do
      Req.new(base_url: client.base_url, auth: {:bearer, client.access_token})
      |> Req.merge(opts)
      # Add custom Req plugins or middleware here
      |> Req.request()
    end
  end
  ```
  """

  @behaviour Humaans.HTTPClient.Behaviour

  require Req

  @doc """
  Makes an HTTP request to the Humaans API using `Req`.

  ## Parameters

  - `client` - `Humaans` struct containing configuration
  - `opts` - Request options to be merged with the Req client

  ## Returns

  - `{:ok, response}` - Successful response with parsed body
  - `{:error, reason}` - Error with reason
  """
  @impl true
  def request(client, opts) do
    opts =
      case Keyword.get(opts, :method) do
        method when method in [:patch, :post, :put] ->
          case Keyword.get(opts, :body) do
            nil ->
              opts

            body ->
              opts
              |> Keyword.delete(:body)
              |> Keyword.put(:json, body)
          end

        _ ->
          opts
      end

    base =
      [base_url: client.base_url, auth: {:bearer, client.access_token}]
      |> Keyword.merge(Map.get(client, :req_options, []))

    base
    |> Req.new()
    |> Req.merge(opts)
    |> Req.request()
  end
end
