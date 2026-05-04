defmodule Humaans.TimeAwayAllocations do
  @moduledoc """
  This module provides functions for managing time away allocation resources
  in the Humaans API.
  """

  use Humaans.Resource,
    path: "/time-away-allocations",
    struct: Humaans.Resources.TimeAwayAllocation,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", timeAwayTypeId: "type_abc", timeAwayPolicyId: "policy_abc", amount: 25, unit: "days", startDate: "2025-01-01"}),
      update: ~s(%{amount: 30})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimeAwayAllocation{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimeAwayAllocation{}} | {:error, Humaans.Error.t()}
end
