defmodule Humaans.Companies do
  @moduledoc """
  This module provides functions for managing company resources in the Humaans
  API.  Note that unlike other resources, companies can only be listed,
  retrieved, and updated, but not created or deleted through the API.
  """

  use Humaans.Resource,
    path: "/companies",
    struct: Humaans.Resources.Company,
    actions: [:list, :retrieve, :update]

  alias Humaans.Resources.Company

  @type list_response :: {:ok, [%Company{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Company{}} | {:error, Humaans.Error.t()}

  @deprecated "Use Humaans.Companies.retrieve/2 instead"
  @spec get(client :: map(), id :: String.t()) :: response()
  def get(client, id), do: retrieve(client, id)
end
