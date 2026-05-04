defmodule Humaans.TimeAwayTypes do
  @moduledoc """
  This module provides functions for managing time away type resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/time-away-types",
    struct: Humaans.Resources.TimeAwayType,
    doc_params: [
      create: ~s(%{name: "Holiday"}),
      update: ~s(%{name: "Annual Leave"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimeAwayType{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimeAwayType{}} | {:error, Humaans.Error.t()}
end
