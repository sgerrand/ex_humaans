defmodule Humaans.Resources.PerformanceSummary do
  @moduledoc """
  Representation of a Performance Summary resource.
  """

  defstruct [
    :id,
    :company_id,
    :person_id,
    :performance_cycle_id,
    :summary,
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
          person_id: binary | nil,
          performance_cycle_id: binary | nil,
          summary: any | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
