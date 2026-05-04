defmodule Humaans.Roles do
  @moduledoc """
  This module provides functions for listing and retrieving role resources
  in the Humaans API.  Roles are read-only via the API.
  """

  use Humaans.Resource,
    path: "/roles",
    struct: Humaans.Resources.Role,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.Role{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Role{}} | {:error, Humaans.Error.t()}
end
