defmodule Humaans.Documents do
  @moduledoc """
  This module provides functions for managing document resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/documents",
    struct: Humaans.Resources.Document,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", documentTypeId: "type_abc", name: "Passport", link: "https://example.com/passport.pdf"}),
      update: ~s|%{name: "Passport (renewed)"}|
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.Document{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Document{}} | {:error, Humaans.Error.t()}
end
