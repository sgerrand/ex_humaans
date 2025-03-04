defmodule Humaans.Companies do
  @moduledoc """
  This module provides functions for managing company resources in the Humaans
  API.  Note that unlike other resources, companies can only be listed,
  retrieved, and updated, but not created or deleted through the API.
  """

  alias Humaans.{Client, Resources.Company, ResponseHandler}

  @type list_response :: {:ok, [%Company{}]} | {:error, any()}
  @type response :: {:ok, %Company{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback get(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all company resources.

  Returns a list of company resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all companies
      {:ok, companies} = Humaans.Companies.list(client)

      # List with filtering parameters
      {:ok, companies} = Humaans.Companies.list(client, %{limit: 10})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/companies", params)
    |> ResponseHandler.handle_list_response(Company)
  end

  @doc """
  Retrieves a specific company by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the company to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, company} = Humaans.Companies.get(client, "company_id")

  """
  @spec get(client :: map(), id :: String.t()) :: response()
  def get(client, id) do
    Client.get(client, "/companies/#{id}")
    |> ResponseHandler.handle_resource_response(Company)
  end

  @doc """
  Updates a specific company by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the company to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{name: "New Company Name"}

      {:ok, updated_company} = Humaans.Companies.update(client, "company_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/companies/#{id}", params)
    |> ResponseHandler.handle_resource_response(Company)
  end
end
