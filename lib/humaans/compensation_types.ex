defmodule Humaans.CompensationTypes do
  @moduledoc """
  Handles operations related to bank accounts.
  """

  alias Humaans.Resources.CompensationType

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%CompensationType{}]} | {:error, any()}
  @type response :: {:ok, %CompensationType{}} | {:error, any()}

  @callback list(map()) :: {:ok, map()} | {:error, any()}
  @callback create(map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(String.t()) :: {:ok, map()} | {:error, any()}

  @client Application.compile_env!(:humaans, :client)

  @spec list(params :: keyword()) :: list_response()
  def list(params \\ %{}) do
    @client.get("/compensation-types", params)
    |> handle_response()
  end

  @spec create(params :: keyword()) :: response()
  def create(params) do
    @client.post("/compensation-types", params)
    |> handle_response()
  end

  @spec retrieve(id :: String.t()) :: response()
  def retrieve(id) do
    @client.get("/compensation-types/#{id}")
    |> handle_response()
  end

  @spec update(id :: String.t(), params :: keyword()) :: response()
  def update(id, params) do
    @client.patch("/compensation-types/#{id}", params)
    |> handle_response()
  end

  @spec delete(id :: String.t()) :: delete_response()
  def delete(id) do
    @client.delete("/compensation-types/#{id}")
    |> handle_response()
  end

  defp handle_response({:ok, %{status: status, body: %{"data" => data}}})
       when status in 200..299 do
    {_r, response} =
      Enum.map_reduce(data, [], fn i, acc ->
        {CompensationType.new(i), [CompensationType.new(i) | acc]}
      end)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: %{"deleted" => deleted, "id" => id}}})
       when status in 200..299 do
    {:ok, %{deleted: deleted, id: id}}
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    response = CompensationType.new(body)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error
end
