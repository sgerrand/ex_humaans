defmodule Humaans.BankAccounts do
  @moduledoc """
  This module provides functions for managing bank account resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/bank-accounts",
    struct: Humaans.Resources.BankAccount

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.BankAccount{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.BankAccount{}} | {:error, Humaans.Error.t()}
end
