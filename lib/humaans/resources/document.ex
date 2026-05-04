defmodule Humaans.Resources.Document do
  @moduledoc """
  Representation of a Document resource.
  """

  defstruct [
    :id,
    :company_id,
    :person_id,
    :name,
    :document_type_id,
    :folder_id,
    :link,
    :file_id,
    :file,
    :source,
    :source_id,
    :issue_date,
    :created_by,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:issue_date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          company_id: binary | nil,
          person_id: binary | nil,
          name: binary | nil,
          document_type_id: binary | nil,
          folder_id: binary | nil,
          link: binary | nil,
          file_id: binary | nil,
          file: map | nil,
          source: binary | nil,
          source_id: binary | nil,
          issue_date: Date.t() | nil,
          created_by: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
