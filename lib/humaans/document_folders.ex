defmodule Humaans.DocumentFolders do
  @moduledoc """
  This module provides functions for managing document folder resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/document-folders",
    struct: Humaans.Resources.DocumentFolder,
    doc_params: [
      create: ~s(%{name: "Onboarding"}),
      update: ~s(%{name: "Onboarding Documents"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.DocumentFolder{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.DocumentFolder{}} | {:error, Humaans.Error.t()}
end
