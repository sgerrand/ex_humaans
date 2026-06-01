defmodule Humaans.Resources.EsignBulk do
  @moduledoc """
  Representation of an Esign Bulk resource.
  """

  defstruct [
    :id,
    :company_id,
    :esign_template_id,
    :name,
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
          esign_template_id: binary | nil,
          name: binary | nil,
          status: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
