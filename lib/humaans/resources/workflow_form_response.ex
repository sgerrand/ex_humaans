defmodule Humaans.Resources.WorkflowFormResponse do
  @moduledoc """
  Representation of a Workflow Form Response resource.
  """

  defstruct [:id, :workflow_id, :person_id, :data, :created_at, :updated_at]

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
          workflow_id: binary | nil,
          person_id: binary | nil,
          data: map | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
