defmodule Humaans.Resources.RequestComment do
  @moduledoc """
  Representation of a Request Comment resource.
  """

  defstruct [:id, :request_id, :person_id, :body, :created_at, :updated_at]

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
          person_id: binary | nil,
          body: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
