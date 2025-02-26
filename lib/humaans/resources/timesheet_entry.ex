defmodule Humaans.Resources.TimesheetEntry do
  @moduledoc """
  Representation of a Timesheet Entry resource.
  """

  defstruct [
    :id,
    :person_id,
    :date,
    :start_time,
    :end_time,
    :duration,
    :created_at,
    :updated_at
  ]

  use ExConstructor

  @type t :: %__MODULE__{
          id: binary,
          person_id: binary,
          date: binary,
          start_time: binary,
          end_time: binary,
          duration: %{hours: integer, minutes: integer} | nil,
          created_at: binary,
          updated_at: binary
        }
end
