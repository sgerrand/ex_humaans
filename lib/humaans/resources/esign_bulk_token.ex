defmodule Humaans.Resources.EsignBulkToken do
  @moduledoc """
  Representation of an Esign Bulk Token resource.
  """

  defstruct [
    :id,
    :esign_bulk_recipient_id,
    :token,
    :expires_at,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:expires_at)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          esign_bulk_recipient_id: binary | nil,
          token: binary | nil,
          expires_at: DateTime.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
