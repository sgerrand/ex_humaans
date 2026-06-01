defmodule Humaans.Resources.EsignInstance do
  @moduledoc """
  Representation of an Esign Instance resource.
  """

  defstruct [
    :id,
    :company_id,
    :esign_template_id,
    :person_id,
    :status,
    :signed_at,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:signed_at)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          company_id: binary | nil,
          esign_template_id: binary | nil,
          person_id: binary | nil,
          status: binary | nil,
          signed_at: DateTime.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
