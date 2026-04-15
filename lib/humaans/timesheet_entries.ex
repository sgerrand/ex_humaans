defmodule Humaans.TimesheetEntries do
  @moduledoc """
  This module provides functions for managing timesheet entry resources in the
  Humaans API. Timesheet entries represent individual time records for a person,
  such as hours worked on a specific date.
  """

  use Humaans.Resource,
    path: "/timesheet-entries",
    struct: Humaans.Resources.TimesheetEntry

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimesheetEntry{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimesheetEntry{}} | {:error, Humaans.Error.t()}
end
