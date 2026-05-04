defmodule Humaans.IdentityDocumentTypes do
  @moduledoc """
  This module provides functions for listing identity document type resources
  in the Humaans API.  Identity document types are read-only via the API.
  """

  use Humaans.Resource,
    path: "/identity-document-types",
    struct: Humaans.Resources.IdentityDocumentType,
    actions: [:list]

  @type list_response ::
          {:ok, [%Humaans.Resources.IdentityDocumentType{}]} | {:error, Humaans.Error.t()}
end
