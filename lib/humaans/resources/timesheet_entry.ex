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
