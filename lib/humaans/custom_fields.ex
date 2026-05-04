defmodule Humaans.CustomFields do
  @moduledoc """
  This module provides functions for managing custom field resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/custom-fields",
    struct: Humaans.Resources.CustomField,
    doc_params: [
      create:
        ~s(%{name: "T-shirt size", section: "basics", type: "select", config: %{choices: ["S", "M", "L"]}}),
      update: ~s(%{name: "Shirt size"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.CustomField{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.CustomField{}} | {:error, Humaans.Error.t()}
end
