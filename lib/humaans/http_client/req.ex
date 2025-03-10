defmodule Humaans.HTTPClient.Req do
  @moduledoc false

  @behaviour Humaans.HTTPClient.Behaviour

  require Req

  @impl true
  def request(client, opts) do
    Req.new(
      base_url: client.base_url,
      auth: {:bearer, client.access_token}
    )
    |> Req.merge(opts)
    |> Req.request()
  end
end
