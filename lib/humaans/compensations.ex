defmodule Humaans.Compensations do
  @moduledoc """
  This module provides functions for managing compensation resources in the
  Humaans API. Compensations represent the actual monetary values assigned to a
  person under a specific compensation type (e.g., a specific person's salary or
  bonus).

  ## Filtering by effective date

  In addition to the standard filter parameters, the Compensations endpoint
  supports `$asOf=YYYY-MM-DD` to return only the compensation records that
  were effective on the given date. Useful for snapshotting compensation as
  of a payroll cut-off:

      # Compensations effective on 2026-01-01
      {:ok, comps} = Humaans.Compensations.list(client, "$asOf": "2026-01-01")

      # Combined with a personId filter
      {:ok, comps} =
        Humaans.Compensations.list(client,
          personId: "person_abc",
          "$asOf": "2026-01-01"
        )
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
