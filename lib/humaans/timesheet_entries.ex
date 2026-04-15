defmodule Humaans.TimesheetEntries do
  @moduledoc """
  This module provides functions for managing timesheet entry resources in the
  Humaans API. Timesheet entries represent individual time records for a person,
  such as hours worked on a specific date.
  """

  use Humaans.Resource,
    path: "/timesheet-entries",
    struct: Humaans.Resources.TimesheetEntry,
    doc_params: [
      create:
        ~s(%{personId: "person_abc", date: "2024-06-01", startTime: "09:00", endTime: "17:00"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimesheetEntry{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimesheetEntry{}} | {:error, Humaans.Error.t()}
end
