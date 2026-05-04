defmodule Humaans.Resources.IdentityDocument do
  @moduledoc """
  Representation of an Identity Document resource.
  """

  defstruct [
    :id,
    :person_id,
    :identity_document_type_id,
    :name,
    :number,
    :issuing_country,
    :issue_date,
    :expiry_date,
    :file_id,
    :file,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:issue_date)
    |> parse_date(:expiry_date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          person_id: binary | nil,
          identity_document_type_id: binary | nil,
          name: binary | nil,
          number: binary | nil,
          issuing_country: binary | nil,
          issue_date: Date.t() | nil,
          expiry_date: Date.t() | nil,
          file_id: binary | nil,
          file: map | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
