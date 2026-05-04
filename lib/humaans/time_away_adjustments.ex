defmodule Humaans.TimeAwayAdjustments do
  @moduledoc """
  This module provides functions for managing time away adjustment resources
  in the Humaans API.
  """

  use Humaans.Resource,
    path: "/time-away-adjustments",
    struct: Humaans.Resources.TimeAwayAdjustment,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", timeAwayAllocationId: "allocation_abc", amount: 1.5, note: "Carry-over"}),
      update: ~s(%{note: "Updated note"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimeAwayAdjustment{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimeAwayAdjustment{}} | {:error, Humaans.Error.t()}
end
