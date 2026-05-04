defmodule Humaans.Resources.TimeAway do
  @moduledoc """
  Representation of a Time Away resource.
  """

  defstruct [
    :id,
    :person_id,
    :time_away_type_id,
    :start_date,
    :end_date,
    :reason,
    :notes,
    :status,
    :approved_by,
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
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          person_id: binary | nil,
          time_away_type_id: binary | nil,
          start_date: Date.t() | nil,
          end_date: Date.t() | nil,
          reason: binary | nil,
          notes: binary | nil,
          status: binary | nil,
          approved_by: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
