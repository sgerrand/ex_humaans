defmodule Humaans.TimeAway do
  @moduledoc """
  This module provides functions for managing time away resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/time-away",
    struct: Humaans.Resources.TimeAway,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", timeAwayTypeId: "type_abc", startDate: "2025-01-01", endDate: "2025-01-05"}),
      update: ~s(%{notes: "Updated note"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.TimeAway{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimeAway{}} | {:error, Humaans.Error.t()}
end
