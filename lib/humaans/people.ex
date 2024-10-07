defmodule Humaans.People do
  @moduledoc """
  Handles operations related to bank accounts.
  """

  alias Humaans.Resources.Person

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%Person{}]} | {:error, any()}
  @type response :: {:ok, %Person{}} | {:error, any()}

  @callback list(map()) :: {:ok, map()} | {:error, any()}
  @callback create(map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(String.t()) :: {:ok, map()} | {:error, any()}

  @client Application.compile_env!(:humaans, :client)

  @spec list(params :: keyword()) :: list_response()
  def list(params \\ %{}) do
    @client.get("/people", params)
    |> handle_response()
  end

  @spec create(params :: keyword()) :: response()
  def create(params) do
    @client.post("/people", params)
    |> handle_response()
  end

  @spec retrieve(id :: String.t()) :: response()
  def retrieve(id) do
    @client.get("/people/#{id}")
    |> handle_response()
  end

  @spec update(id :: String.t(), params :: keyword()) :: response()
  def update(id, params) do
    @client.patch("/people/#{id}", params)
    |> handle_response()
  end

  @spec delete(id :: String.t()) :: delete_response()
  def delete(id) do
    @client.delete("/people/#{id}")
    |> handle_response()
  end

  defp handle_response({:ok, %{status: status, body: %{"data" => data}}})
       when status in 200..299 do
    {_r, response} =
      Enum.map_reduce(data, [], fn i, acc ->
        {Person.new(i), [Person.new(i) | acc]}
      end)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: %{"deleted" => deleted, "id" => id}}})
       when status in 200..299 do
    {:ok, %{deleted: deleted, id: id}}
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    response = Person.new(body)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error
end
