defmodule Humaans.Resources.Equipment do
  @moduledoc """
  Representation of an Equipment resource.
  """

  defstruct [
    :id,
    :person_id,
    :equipment_type_id,
    :equipment_name_id,
    :serial_number,
    :assigned_date,
    :returned_date,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:assigned_date)
    |> parse_date(:returned_date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          person_id: binary | nil,
          equipment_type_id: binary | nil,
          equipment_name_id: binary | nil,
          serial_number: binary | nil,
          assigned_date: Date.t() | nil,
          returned_date: Date.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
