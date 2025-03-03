defmodule Humaans.Companies do
  @moduledoc """
  Handles operations related to companies.
  """

  alias Humaans.{Client, Resources.Company}

  @type list_response :: {:ok, [%Company{}]} | {:error, any()}
  @type response :: {:ok, %Company{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback get(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}

  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/companies", params)
    |> handle_response()
  end

  @spec get(client :: map(), id :: String.t()) :: response()
  def get(client, id) do
    Client.get(client, "/companies/#{id}")
    |> handle_response()
  end

  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/companies/#{id}", params)
    |> handle_response()
  end

  defp handle_response({:ok, %{status: status, body: %{"data" => data}}})
       when status in 200..299 do
    {_r, response} =
      Enum.map_reduce(data, [], fn i, acc ->
        {Company.new(i), [Company.new(i) | acc]}
      end)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    response = Company.new(body)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error
end
