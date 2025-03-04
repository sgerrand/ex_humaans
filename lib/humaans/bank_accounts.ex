defmodule Humaans.BankAccounts do
  @moduledoc """
  This module provides functions for managing bank account resources in the
  Humaans API.
  """

  alias Humaans.{Client, Resources.BankAccount, ResponseHandler}

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%BankAccount{}]} | {:error, any()}
  @type response :: {:ok, %BankAccount{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback create(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all bank account resources.

  Returns a list of bank account resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all bank accounts
      {:ok, accounts} = Humaans.BankAccounts.list(client)

      # List with filtering parameters
      {:ok, accounts} = Humaans.BankAccounts.list(client, %{limit: 10})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/bank-accounts", params)
    |> ResponseHandler.handle_list_response(BankAccount)
  end

  @doc """
  Creates a new bank account resource.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Map of parameters for the new bank account

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{
        personId: "person_id",
        accountType: "personal",
        accountHolder: "Jane Doe",
        accountNumber: "12345678",
        sortCode: "01-02-03"
      }

      {:ok, account} = Humaans.BankAccounts.create(client, params)

  """
  @spec create(client :: map(), params :: keyword()) :: response()
  def create(client, params) do
    Client.post(client, "/bank-accounts", params)
    |> ResponseHandler.handle_resource_response(BankAccount)
  end

  @doc """
  Retrieves a specific bank account by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the bank account to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, account} = Humaans.BankAccounts.retrieve(client, "account_id")

  """
  @spec retrieve(client :: map(), id :: String.t()) :: response()
  def retrieve(client, id) do
    Client.get(client, "/bank-accounts/#{id}")
    |> ResponseHandler.handle_resource_response(BankAccount)
  end

  @doc """
  Updates a specific bank account by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the bank account to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{accountHolder: "Janet Doe"}

      {:ok, updated_account} = Humaans.BankAccounts.update(client, "account_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/bank-accounts/#{id}", params)
    |> ResponseHandler.handle_resource_response(BankAccount)
  end

  @doc """
  Deletes a specific bank account by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the bank account to delete

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, result} = Humaans.BankAccounts.delete(client, "account_id")
      # result contains %{id: "account_id", deleted: true}

  """
  @spec delete(client :: map(), id :: String.t()) :: delete_response()
  def delete(client, id) do
    Client.delete(client, "/bank-accounts/#{id}")
    |> ResponseHandler.handle_delete_response()
  end
end
