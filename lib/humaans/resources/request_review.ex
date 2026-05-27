defmodule Humaans.Resources.RequestReview do
  @moduledoc """
  Representation of a Request Review resource.
  """

  defstruct [
    :id,
    :request_id,
    :reviewer_id,
    :status,
    :decision,
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
          request_id: binary | nil,
          reviewer_id: binary | nil,
          status: binary | nil,
          decision: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
