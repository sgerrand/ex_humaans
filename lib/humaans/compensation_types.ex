defmodule Humaans.CompensationTypes do
  @moduledoc """
  This module provides functions for managing compensation type resources in the
  Humaans API. Compensation types are used to define different categories of
  compensation such as salary, bonus, commission, etc.
  """

  alias Humaans.{Client, Resources.CompensationType, ResponseHandler}

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%CompensationType{}]} | {:error, any()}
  @type response :: {:ok, %CompensationType{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback create(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all compensation type resources.

  Returns a list of compensation type resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all compensation types
      {:ok, types} = Humaans.CompensationTypes.list(client)

      # List with filtering parameters
      {:ok, types} = Humaans.CompensationTypes.list(client, %{limit: 10})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/compensation-types", params)
    |> ResponseHandler.handle_list_response(CompensationType)
  end

  @doc """
  Creates a new compensation type resource.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Map of parameters for the new compensation type

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{
        name: "Annual Bonus",
        category: "bonus",
        payFrequency: "once",
        recurring: true
      }

      {:ok, comp_type} = Humaans.CompensationTypes.create(client, params)

  """
  @spec create(client :: map(), params :: keyword()) :: response()
  def create(client, params) do
    Client.post(client, "/compensation-types", params)
    |> ResponseHandler.handle_resource_response(CompensationType)
  end

  @doc """
  Retrieves a specific compensation type by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the compensation type to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, comp_type} = Humaans.CompensationTypes.retrieve(client, "type_id")

  """
  @spec retrieve(client :: map(), id :: String.t()) :: response()
  def retrieve(client, id) do
    Client.get(client, "/compensation-types/#{id}")
    |> ResponseHandler.handle_resource_response(CompensationType)
  end

  @doc """
  Updates a specific compensation type by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the compensation type to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{name: "Quarterly Bonus", payFrequency: "quarterly"}

      {:ok, updated_type} = Humaans.CompensationTypes.update(client, "type_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/compensation-types/#{id}", params)
    |> ResponseHandler.handle_resource_response(CompensationType)
  end

  @doc """
  Deletes a specific compensation type by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the compensation type to delete

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, result} = Humaans.CompensationTypes.delete(client, "type_id")
      # result contains %{id: "type_id", deleted: true}

  """
  @spec delete(client :: map(), id :: String.t()) :: delete_response()
  def delete(client, id) do
    Client.delete(client, "/compensation-types/#{id}")
    |> ResponseHandler.handle_delete_response()
  end
end
