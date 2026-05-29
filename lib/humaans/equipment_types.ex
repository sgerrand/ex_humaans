defmodule Humaans.EquipmentTypes do
  @moduledoc """
  This module provides functions for listing equipment type resources in the
  Humaans API.  Equipment types are read-only via the API.
  """

  use Humaans.Resource,
    path: "/equipment-types",
    struct: Humaans.Resources.EquipmentType,
    actions: [:list]

  @type list_response :: {:ok, [%Humaans.Resources.EquipmentType{}]} | {:error, Humaans.Error.t()}
end
