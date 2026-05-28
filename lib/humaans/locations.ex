defmodule Humaans.Locations do
  @moduledoc """
  This module provides functions for managing location resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/locations",
    struct: Humaans.Resources.Location,
    doc_params: [
      create: ~s(%{name: "London HQ"}),
      update: ~s(%{name: "London Office"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.Location{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Location{}} | {:error, Humaans.Error.t()}
end
