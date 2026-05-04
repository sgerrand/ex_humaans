defmodule Humaans.Resources.PerformanceCycle do
  @moduledoc """
  Representation of a Performance Cycle resource.
  """

  defstruct [
    :id,
    :company_id,
    :name,
    :status,
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
          company_id: binary | nil,
          name: binary | nil,
          status: binary | nil,
          start_date: Date.t() | nil,
          end_date: Date.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
