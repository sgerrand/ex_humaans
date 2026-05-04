defmodule Humaans.DocumentTypes do
  @moduledoc """
  This module provides functions for managing document type resources in the
  Humaans API.  Note that document types do not support deletion.
  """

  use Humaans.Resource,
    path: "/document-types",
    struct: Humaans.Resources.DocumentType,
    actions: [:list, :create, :retrieve, :update],
    doc_params: [
      create: ~s(%{name: "Passport"}),
      update: ~s(%{name: "Identity Document"})
    ]

  @type list_response :: {:ok, [%Humaans.Resources.DocumentType{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.DocumentType{}} | {:error, Humaans.Error.t()}
end
