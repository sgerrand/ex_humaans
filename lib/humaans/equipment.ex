defmodule Humaans.Equipment do
  @moduledoc """
  This module provides functions for managing equipment resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/equipment",
    struct: Humaans.Resources.Equipment,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", equipmentTypeId: "type_abc", equipmentNameId: "name_abc", serialNumber: "ABC-123"}),
      update: ~s(%{returnedDate: "2025-12-31"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.Equipment{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Equipment{}} | {:error, Humaans.Error.t()}
end
