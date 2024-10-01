defmodule Humaans.Client.Req do
  @moduledoc false

  @behaviour Humaans.Client

  require Req

  alias Humaans.Response

  @base_url "https://app.humaans.io/api"

  @spec new() :: Req.Request.t()
  def new do
    Req.new(
      base_url: @base_url,
      auth: {:bearer, api_key()},
      headers: [{"Accept", "application/json"}]
    )
  end

  @impl true
  @spec delete(path :: String.t()) :: Response.t()
  def delete(path) do
    new()
    |> Req.delete(url: path)
  end

  @impl true
  @spec get(path :: String.t()) :: Response.t()
  def get(path) do
    new()
    |> Req.get(url: path)
  end

  @impl true
  @spec get(path :: String.t(), params :: keyword()) :: Response.t()
  def get(path, params) do
    new()
    |> Req.get(url: path, params: params)
  end

  @impl true
  @spec post(path :: String.t(), params :: keyword()) :: Response.t()
  def post(path, params \\ []) do
    new()
    |> Req.post(url: path, params: params)
  end

  @impl true
  @spec patch(path :: String.t(), params :: keyword()) :: Response.t()
  def patch(path, params \\ []) do
    new()
    |> Req.patch(url: path, params: params)
  end

  defp api_key do
    System.get_env("HUMAANS_API_KEY") ||
      raise "Environment variable HUMAANS_API_KEY is not set"
  end
end
