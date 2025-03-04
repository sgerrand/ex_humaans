defmodule Humaans.ResponseHandler do
  @moduledoc """
  This module provides helper functions for handling API responses consistently
  across all Humaans API resource modules.
  """

  @doc """
  Handles responses for list operations, converting raw API response data into a list of resource structs.

  ## Parameters

    * `response` - The response tuple from the HTTP client
    * `resource_module` - The module to use for converting the raw data to structs

  ## Examples

      response = Client.get(client, "/endpoint", params)
      ResponseHandler.handle_list_response(response, Resources.Person)

  """
  @spec handle_list_response({:ok, map()} | {:error, any()}, module()) ::
          {:ok, [struct()]} | {:error, any()}
  def handle_list_response(response, resource_module) do
    handle_response(response, fn data ->
      {_r, resources} =
        Enum.map_reduce(data, [], fn item, acc ->
          resource = resource_module.new(item)
          {resource, [resource | acc]}
        end)

      resources
    end)
  end

  @doc """
  Handles responses for single resource operations, converting raw API response data into a resource struct.

  ## Parameters

    * `response` - The response tuple from the HTTP client
    * `resource_module` - The module to use for converting the raw data to a struct

  ## Examples

      response = Client.get(client, "/endpoint/id")
      ResponseHandler.handle_resource_response(response, Resources.Person)

  """
  @spec handle_resource_response({:ok, map()} | {:error, any()}, module()) ::
          {:ok, struct()} | {:error, any()}
  def handle_resource_response(response, resource_module) do
    handle_response(response, fn body ->
      resource_module.new(body)
    end)
  end

  @doc """
  Handles responses for delete operations, returning a map with deleted status and ID.

  ## Parameters

    * `response` - The response tuple from the HTTP client

  ## Examples

      response = Client.delete(client, "/endpoint/id")
      ResponseHandler.handle_delete_response(response)

  """
  @spec handle_delete_response({:ok, map()} | {:error, any()}) ::
          {:ok, %{deleted: boolean(), id: String.t()}} | {:error, any()}
  def handle_delete_response(response) do
    case response do
      {:ok, %{status: status, body: %{"deleted" => deleted, "id" => id}}}
      when status in 200..299 ->
        {:ok, %{deleted: deleted, id: id}}

      response ->
        handle_response(response, fn _ -> nil end)
    end
  end

  @doc """
  Generic response handler for all API operations.

  ## Parameters

    * `response` - The response tuple from the HTTP client
    * `success_handler` - A function to process successful response bodies

  """
  @spec handle_response({:ok, map()} | {:error, any()}, (any() -> any())) ::
          {:ok, any()} | {:error, any()}
  def handle_response(response, success_handler) do
    case response do
      {:ok, %{status: status, body: %{"data" => data}}} when status in 200..299 ->
        {:ok, success_handler.(data)}

      {:ok, %{status: status, body: body}} when status in 200..299 ->
        {:ok, success_handler.(body)}

      {:ok, %{status: status, body: body}} ->
        {:error, {status, body}}

      {:error, _} = error ->
        error
    end
  end
end
