defmodule Humaans.RoleMembers do
  @moduledoc """
  This module provides functions for listing and retrieving role member
  resources in the Humaans API.  Role members are read-only via the API.
  """

  use Humaans.Resource,
    path: "/role-members",
    struct: Humaans.Resources.RoleMember,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.RoleMember{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.RoleMember{}} | {:error, Humaans.Error.t()}
end
