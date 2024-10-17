defmodule Humaans.Resources.TimesheetSubmission do
  @moduledoc """
  Representation of a Timesheet Submission resource.
  """

  defstruct [
    :id,
    :person_id,
    :start_date,
    :end_date,
    :status,
    :submitted_at,
    :reviewed_by,
    :reviewed_at,
    :changes_requested,
    :duration_as_time,
    :duration_as_days,
    :created_at,
    :updated_at
  ]

  use ExConstructor

  @type t :: %__MODULE__{
          id: binary,
          person_id: binary,
          start_date: binary,
          end_date: binary,
          status: :pending | :approved | :rejected,
          submitted_at: binary,
          reviewed_by: binary,
          reviewed_at: binary,
          changes_requested: binary | nil,
          duration_as_time: %{hours: integer, minutes: integer} | nil,
          duration_as_days: integer | nil,
          created_at: binary,
          updated_at: binary
        }
end
