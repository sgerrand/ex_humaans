defmodule Humaans.HTTPClient.Req do
  @moduledoc """
  Default HTTP client implementation using `Req`.

  This module is used by default when you create a new Humaans client without
  specifying a custom HTTP client.

  ## Customization

  If you need to customize the Req client behavior (such as adding middleware,
  changing timeouts, etc.), you can implement your own client module that builds
  on this implementation while adding your specific modifications.

  ```elixir
  defmodule MyCustomReqClient do
    @behaviour Humaans.HTTPClient.Behaviour

    @impl true
    def request(client, opts) do
      Req.new(
        base_url: client.base_url,
        auth: {:bearer, client.access_token},
        connect_options: [timeout: 30_000] # Custom timeout
      )
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
    method = Keyword.get(opts, :method)

    opts =
      Enum.reduce(opts, [], fn opt, acc ->
        case opt do
          {:body, body} when method in [:patch, :post, :put] -> [{:json, body} | acc]
          {:body, body} -> [{:body, body} | acc]
          {key, val} -> [{key, val} | acc]
        end
      end)

    Req.new(
      base_url: client.base_url,
      auth: {:bearer, client.access_token}
    )
    |> Req.merge(opts)
    |> Req.request()
  end
end
