defmodule Humaans.CustomValues do
  @moduledoc """
  This module provides functions for managing custom value resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/custom-values",
    struct: Humaans.Resources.CustomValue,
    doc_params: [
      create: ~s(%{personId: "person_abc", customFieldId: "cf_abc", value: "M"}),
      update: ~s(%{value: "L"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.CustomValue{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.CustomValue{}} | {:error, Humaans.Error.t()}
end
