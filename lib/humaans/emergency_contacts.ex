defmodule Humaans.EmergencyContacts do
  @moduledoc """
  This module provides functions for managing emergency contact resources in
  the Humaans API.
  """

  use Humaans.Resource,
    path: "/emergency-contacts",
    struct: Humaans.Resources.EmergencyContact,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", name: "Jane Doe", relationship: "Sibling", phoneNumber: "+44 7700 900000"}),
      update: ~s(%{phoneNumber: "+44 7700 900001"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.EmergencyContact{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.EmergencyContact{}} | {:error, Humaans.Error.t()}
end
