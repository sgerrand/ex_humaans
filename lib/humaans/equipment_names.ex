defmodule Humaans.EquipmentNames do
  @moduledoc """
  This module provides functions for listing equipment name resources in the
  Humaans API.  Equipment names are read-only via the API.
  """

  use Humaans.Resource,
    path: "/equipment-names",
    struct: Humaans.Resources.EquipmentName,
    actions: [:list]

  @type list_response :: {:ok, [%Humaans.Resources.EquipmentName{}]} | {:error, Humaans.Error.t()}
end
