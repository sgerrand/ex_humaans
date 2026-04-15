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

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:start_date)
    |> parse_date(:end_date)
    |> parse_datetime(:submitted_at)
    |> parse_datetime(:reviewed_at)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary,
          person_id: binary,
          start_date: Date.t() | nil,
          end_date: Date.t() | nil,
          status: :pending | :approved | :rejected,
          submitted_at: DateTime.t() | nil,
          reviewed_by: binary,
          reviewed_at: DateTime.t() | nil,
          changes_requested: binary | nil,
          duration_as_time: %{hours: integer, minutes: integer} | nil,
          duration_as_days: integer | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
