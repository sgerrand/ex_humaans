defmodule Humaans.Resources.EsignTemplate do
  @moduledoc """
  Representation of an Esign Template resource.
  """

  defstruct [
    :id,
    :company_id,
    :name,
    :body,
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
          name: binary | nil,
          body: binary | nil,
          status: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
