defmodule Humaans.TimesheetSubmissions do
  @moduledoc """
  This module provides functions for managing timesheet submission resources in
  the Humaans API. Timesheet submissions represent a collection of timesheet
  entries for a specific time period that has been submitted for review and
  approval.
  """

  use Humaans.Resource,
    path: "/timesheet-submissions",
    struct: Humaans.Resources.TimesheetSubmission,
    doc_params: [
      create: ~s(%{personId: "person_abc", startDate: "2024-06-01", endDate: "2024-06-30"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimesheetSubmission{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimesheetSubmission{}} | {:error, Humaans.Error.t()}
end
