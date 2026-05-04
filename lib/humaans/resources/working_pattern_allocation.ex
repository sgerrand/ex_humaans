defmodule Humaans.Resources.WorkingPatternAllocation do
  @moduledoc """
  Representation of a Working Pattern Allocation resource.
  """

  defstruct [
    :id,
    :person_id,
    :working_pattern_id,
    :start_date,
    :end_date,
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
          working_pattern_id: binary | nil,
          start_date: Date.t() | nil,
          end_date: Date.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
