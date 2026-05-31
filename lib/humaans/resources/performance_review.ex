defmodule Humaans.Resources.PerformanceReview do
  @moduledoc """
  Representation of a Performance Review resource.
  """

  defstruct [
    :id,
    :company_id,
    :person_id,
    :performance_instance_id,
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
          person_id: binary | nil,
          performance_instance_id: binary | nil,
          status: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
