defmodule Humaans.Resources.Task do
  @moduledoc """
  Representation of a Task resource.
  """

  defstruct [
    :id,
    :company_id,
    :person_id,
    :title,
    :description,
    :status,
    :priority,
    :due_date,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:due_date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          company_id: binary | nil,
          person_id: binary | nil,
          title: binary | nil,
          description: binary | nil,
          status: binary | nil,
          priority: binary | nil,
          due_date: Date.t() | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
