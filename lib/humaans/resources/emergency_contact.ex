defmodule Humaans.Resources.EmergencyContact do
  @moduledoc """
  Representation of an Emergency Contact resource.
  """

  defstruct [
    :id,
    :person_id,
    :name,
    :relationship,
    :phone_number,
    :email,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          person_id: binary | nil,
          name: binary | nil,
          relationship: binary | nil,
          phone_number: binary | nil,
          email: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
