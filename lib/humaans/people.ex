defmodule Humaans.People do
  @moduledoc """
  This module provides functions for managing people resources in the Humaans
  API.
  """

  alias Humaans.{Client, Resources.Person, ResponseHandler}

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%Person{}]} | {:error, any()}
  @type response :: {:ok, %Person{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback create(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all people resources.

  Returns a list of people resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all people
      {:ok, people} = Humaans.People.list(client)

      # List with filtering parameters
      {:ok, people} = Humaans.People.list(client, %{limit: 10})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/people", params)
    |> ResponseHandler.handle_list_response(Person)
  end

  @doc """
  Creates a new person resource.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Map of parameters for the new person

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{
        firstName: "Jane",
        lastName: "Doe",
        email: "jane@example.com"
      }

      {:ok, person} = Humaans.People.create(client, params)

  """
  @spec create(client :: map(), params :: keyword()) :: response()
  def create(client, params) do
    Client.post(client, "/people", params)
    |> ResponseHandler.handle_resource_response(Person)
  end

  @doc """
  Retrieves a specific person by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the person to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, person} = Humaans.People.retrieve(client, "person_id")

  """
  @spec retrieve(client :: map(), id :: String.t()) :: response()
  def retrieve(client, id) do
    Client.get(client, "/people/#{id}")
    |> ResponseHandler.handle_resource_response(Person)
  end

  @doc """
  Updates a specific person by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the person to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{firstName: "Janet"}

      {:ok, updated_person} = Humaans.People.update(client, "person_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/people/#{id}", params)
    |> ResponseHandler.handle_resource_response(Person)
  end

  @doc """
  Deletes a specific person by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the person to delete

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, result} = Humaans.People.delete(client, "person_id")
      # result contains %{id: "person_id", deleted: true}

  """
  @spec delete(client :: map(), id :: String.t()) :: delete_response()
  def delete(client, id) do
    Client.delete(client, "/people/#{id}")
    |> ResponseHandler.handle_delete_response()
  end
end
