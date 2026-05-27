defmodule Humaans.Resources.RequestActivityLog do
  @moduledoc """
  Representation of a Request Activity Log resource.
  """

  defstruct [:id, :request_id, :person_id, :action, :data, :created_at]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:created_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          request_id: binary | nil,
          person_id: binary | nil,
          action: binary | nil,
          data: map | nil,
          created_at: DateTime.t() | nil
        }
end
