defmodule Humaans.IdentityDocuments do
  @moduledoc """
  This module provides functions for managing identity document resources in
  the Humaans API.
  """

  use Humaans.Resource,
    path: "/identity-documents",
    struct: Humaans.Resources.IdentityDocument,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", identityDocumentTypeId: "type_abc", name: "UK Passport", number: "123456789"}),
      update: ~s(%{number: "987654321"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.IdentityDocument{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.IdentityDocument{}} | {:error, Humaans.Error.t()}
end
