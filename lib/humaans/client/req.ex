defmodule Humaans.Client.Req do
  @moduledoc false

  @behaviour Humaans.Client

  require Req

  alias Humaans.Response

  @impl true
  @spec delete(client :: map(), path :: String.t()) :: Response.t()
  def delete(client, path) do
    client.req
    |> Req.delete(url: path)
  end

  @impl true
  @spec get(client :: map(), path :: String.t()) :: Response.t()
  def get(client, path) do
    client.req
    |> Req.get(url: path)
  end

  @impl true
  @spec get(client :: map(), path :: String.t(), params :: keyword()) :: Response.t()
  def get(client, path, params) do
    client.req
    |> Req.get(url: path, params: params)
  end

  @impl true
  @spec post(client :: map(), path :: String.t(), params :: keyword()) :: Response.t()
  def post(client, path, params \\ []) do
    client.req
    |> Req.post(url: path, params: params)
  end

  @impl true
  @spec patch(client :: map(), path :: String.t(), params :: keyword()) :: Response.t()
  def patch(client, path, params \\ []) do
    client.req
    |> Req.patch(url: path, params: params)
  end
end
