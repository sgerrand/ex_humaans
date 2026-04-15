defmodule Humaans.Compensations do
  @moduledoc """
  This module provides functions for managing compensation resources in the
  Humaans API. Compensations represent the actual monetary values assigned to a
  person under a specific compensation type (e.g., a specific person's salary or
  bonus).
  """

  use Humaans.Resource,
    path: "/compensations",
    struct: Humaans.Resources.Compensation,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", compensationTypeId: "type_abc", amount: 75_000, currency: "GBP", period: "year", effectiveDate: "2024-01-01"}),
      update: ~s(%{amount: 80_000})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.Compensation{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Compensation{}} | {:error, Humaans.Error.t()}
end
