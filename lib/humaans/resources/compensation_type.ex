defmodule Humaans.Resources.CompensationType do
  @moduledoc """
  Representation of a Compensation Type resource.
  """

  defstruct [
    :id,
    :company_id,
    :name,
    :base_type,
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

  @type base_type :: :salary | :bonus | :commission | :equity | :custom
  @type t :: %__MODULE__{
          id: binary,
          company_id: binary,
          name: binary | nil,
          base_type: base_type(),
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
