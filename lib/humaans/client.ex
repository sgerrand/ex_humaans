defmodule Humaans.Client do
  @moduledoc """
  Module for making client requests.
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
