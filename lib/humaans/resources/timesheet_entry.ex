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

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary,
          person_id: binary,
          date: Date.t() | nil,
          start_time: binary,
          end_time: binary,
          duration: %{hours: integer, minutes: integer} | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
