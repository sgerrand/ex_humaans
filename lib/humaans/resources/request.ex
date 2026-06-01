defmodule Humaans.Resources.Request do
  @moduledoc """
  Representation of a Request resource.
  """

  defstruct [
    :id,
    :company_id,
    :person_id,
    :request_type_id,
    :status,
    :data,
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
          request_type_id: binary | nil,
          status: binary | nil,
          data: map | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
