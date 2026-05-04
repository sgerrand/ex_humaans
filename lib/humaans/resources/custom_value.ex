defmodule Humaans.Resources.CustomValue do
  @moduledoc """
  Representation of a Custom Value resource.
  """

  defstruct [
    :id,
    :person_id,
    :custom_field_id,
    :resource_id,
    :value,
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
          custom_field_id: binary | nil,
          resource_id: binary | nil,
          value: binary | [binary] | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
