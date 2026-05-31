defmodule Humaans.Resources.PerformanceCyclePeerNomination do
  @moduledoc """
  Representation of a Performance Cycle Peer Nomination resource.
  """

  defstruct [
    :id,
    :company_id,
    :performance_cycle_id,
    :person_id,
    :nominee_id,
    :status,
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
          company_id: binary | nil,
          performance_cycle_id: binary | nil,
          person_id: binary | nil,
          nominee_id: binary | nil,
          status: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
