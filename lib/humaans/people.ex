defmodule Humaans.People do
  @moduledoc """
  This module provides functions for managing people resources in the Humaans
  API.
  """

  use Humaans.Resource,
    path: "/people",
    struct: Humaans.Resources.Person

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.Person{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Person{}} | {:error, Humaans.Error.t()}
end
