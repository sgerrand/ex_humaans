defmodule Humaans.Resources.CustomField do
  @moduledoc """
  Representation of a Custom Field resource.
  """

  defstruct [
    :id,
    :company_id,
    :name,
    :section,
    :resource_id,
    :type,
    :config,
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
          name: binary | nil,
          section: binary | nil,
          resource_id: binary | nil,
          type: binary | nil,
          config: map | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
