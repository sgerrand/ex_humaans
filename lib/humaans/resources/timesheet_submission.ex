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

  defp parse_date(struct, field) do
    case Map.get(struct, field) do
      nil ->
        struct

      "" ->
        struct

      value when is_binary(value) ->
        case Date.from_iso8601(value) do
          {:ok, date} -> Map.put(struct, field, date)
          {:error, _} -> struct
        end

      _ ->
        struct
    end
  end

  defp parse_datetime(struct, field) do
    case Map.get(struct, field) do
      nil ->
        struct

      "" ->
        struct

      value when is_binary(value) ->
        case DateTime.from_iso8601(value) do
          {:ok, datetime, _offset} -> Map.put(struct, field, datetime)
          {:error, _} -> struct
        end

      _ ->
        struct
    end
  end
end
