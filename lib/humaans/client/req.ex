defmodule Humaans.Client.Req do
  @moduledoc false

  @behaviour Humaans.Client

  require Req

  alias Humaans.Response

  @base_url "https://app.humaans.io/api"

  @impl true
  @spec delete(path :: String.t()) :: Response.t()
  def delete(path) do
    build_client()
    |> Req.delete(url: path)
  end

  @impl true
  @spec get(path :: String.t()) :: Response.t()
  def get(path) do
    build_client()
    |> Req.get(url: path)
  end

  @impl true
  @spec get(path :: String.t(), params :: keyword()) :: Response.t()
  def get(path, params) do
    build_client()
    |> Req.get(url: path, params: params)
  end

  @impl true
  @spec post(path :: String.t(), params :: keyword()) :: Response.t()
  def post(path, params \\ []) do
    build_client()
    |> Req.post(url: path, params: params)
  end

  @impl true
  @spec patch(path :: String.t(), params :: keyword()) :: Response.t()
  def patch(path, params \\ []) do
    build_client()
    |> Req.patch(url: path, params: params)
  end

  defp build_client do
    case Application.fetch_env(:humaans, :access_token) do
      :error ->
        raise "No :access_token configuration was found"

      {:ok, access_token} ->
        Req.new(
          base_url: @base_url,
          auth: {:bearer, access_token},
          headers: [{"Accept", "application/json"}]
        )
    end
  end
end
