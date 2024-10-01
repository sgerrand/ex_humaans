defmodule Humaans.Companies do
  @moduledoc """
  Handles operations related to bank accounts.
  """

  alias Humaans.Resources.Company

  @type list_response :: {:ok, [%Company{}]} | {:error, any()}
  @type response :: {:ok, %Company{}} | {:error, any()}

  @callback list(map()) :: {:ok, map()} | {:error, any()}
  @callback get(String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(String.t(), map()) :: {:ok, map()} | {:error, any()}

  @client Application.compile_env!(:humaans, :client)

  @spec list(params :: keyword()) :: list_response()
  def list(params \\ %{}) do
    @client.get("/companies", params)
    |> handle_response()
  end

  @spec get(id :: String.t()) :: response()
  def get(id) do
    @client.get("/companies/#{id}")
    |> handle_response()
  end

  @spec update(id :: String.t(), params :: keyword()) :: response()
  def update(id, params) do
    @client.patch("/companies/#{id}", params)
    |> handle_response()
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error
end
