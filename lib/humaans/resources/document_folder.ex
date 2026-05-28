defmodule Humaans.Resources.DocumentFolder do
  @moduledoc """
  Representation of a Document Folder resource.
  """

  defstruct [
    :id,
    :company_id,
    :name,
    :audience,
    :created_by,
    :created_at,
    :updated_at,
    :deleted_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
    |> parse_datetime(:deleted_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          company_id: binary | nil,
          name: binary | nil,
          audience: map | nil,
          created_by: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil,
          deleted_at: DateTime.t() | nil
        }
end
