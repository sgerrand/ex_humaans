defmodule Humaans.RolePermissions do
  @moduledoc """
  This module provides functions for listing and retrieving role permission
  resources in the Humaans API.  Role permissions are read-only via the API.
  """

  use Humaans.Resource,
    path: "/role-permissions",
    struct: Humaans.Resources.RolePermission,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.RolePermission{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.RolePermission{}} | {:error, Humaans.Error.t()}
end
