defmodule Humaans.WorkingPatternAllocations do
  @moduledoc """
  This module provides functions for managing working pattern allocation
  resources in the Humaans API.
  """

  use Humaans.Resource,
    path: "/working-pattern-allocations",
    struct: Humaans.Resources.WorkingPatternAllocation,
    doc_params: [
      create: ~s(%{personId: "person_abc", workingPatternId: "wp_abc", startDate: "2025-01-01"}),
      update: ~s(%{endDate: "2025-12-31"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.WorkingPatternAllocation{}]} | {:error, Humaans.Error.t()}
  @type response ::
          {:ok, %Humaans.Resources.WorkingPatternAllocation{}} | {:error, Humaans.Error.t()}
end
