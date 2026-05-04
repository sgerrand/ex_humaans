defmodule Humaans.Spaces do
  @moduledoc """
  This module provides functions for managing space (team/department)
  resources in the Humaans API.
  """

  use Humaans.Resource,
    path: "/spaces",
    struct: Humaans.Resources.Space,
    doc_params: [
      create: ~s(%{name: "Engineering"}),
      update: ~s(%{name: "Platform Engineering"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.Space{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Space{}} | {:error, Humaans.Error.t()}
end
