defmodule Humaans.Compensations do
  @moduledoc """
  This module provides functions for managing compensation resources in the
  Humaans API. Compensations represent the actual monetary values assigned to a
  person under a specific compensation type (e.g., a specific person's salary or
  bonus).
  """

  alias Humaans.{Client, Resources.Compensation, ResponseHandler}

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%Compensation{}]} | {:error, any()}
  @type response :: {:ok, %Compensation{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback create(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all compensation resources.

  Returns a list of compensation resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all compensations
      {:ok, compensations} = Humaans.Compensations.list(client)

      # List with filtering parameters
      {:ok, compensations} = Humaans.Compensations.list(client, %{personId: "person_id"})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/compensations", params)
    |> ResponseHandler.handle_list_response(Compensation)
  end

  @doc """
  Creates a new compensation resource.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Map of parameters for the new compensation

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{
        personId: "person_id",
        compensationTypeId: "comp_type_id",
        amount: "70000",
        currency: "EUR",
        period: "annual",
        effectiveDate: "2023-01-01"
      }

      {:ok, compensation} = Humaans.Compensations.create(client, params)

  """
  @spec create(client :: map(), params :: keyword()) :: response()
  def create(client, params) do
    Client.post(client, "/compensations", params)
    |> ResponseHandler.handle_resource_response(Compensation)
  end

  @doc """
  Retrieves a specific compensation by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the compensation to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, compensation} = Humaans.Compensations.retrieve(client, "comp_id")

  """
  @spec retrieve(client :: map(), id :: String.t()) :: response()
  def retrieve(client, id) do
    Client.get(client, "/compensations/#{id}")
    |> ResponseHandler.handle_resource_response(Compensation)
  end

  @doc """
  Updates a specific compensation by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the compensation to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{amount: "75000", note: "Annual raise"}

      {:ok, updated_comp} = Humaans.Compensations.update(client, "comp_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/compensations/#{id}", params)
    |> ResponseHandler.handle_resource_response(Compensation)
  end

  @doc """
  Deletes a specific compensation by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the compensation to delete

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, result} = Humaans.Compensations.delete(client, "comp_id")
      # result contains %{id: "comp_id", deleted: true}

  """
  @spec delete(client :: map(), id :: String.t()) :: delete_response()
  def delete(client, id) do
    Client.delete(client, "/compensations/#{id}")
    |> ResponseHandler.handle_delete_response()
  end
end
