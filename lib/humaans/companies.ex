defmodule Humaans.Companies do
  @moduledoc """
  This module provides functions for managing company resources in the Humaans
  API.  Note that unlike other resources, companies can only be listed,
  retrieved, and updated, but not created or deleted through the API.
  """

  use Humaans.Resource,
    path: "/companies",
    struct: Humaans.Resources.Company,
    actions: [:list, :update]

  alias Humaans.{Client, Resources.Company, ResponseHandler}

  @type list_response :: {:ok, [%Company{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Company{}} | {:error, Humaans.Error.t()}

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
end
