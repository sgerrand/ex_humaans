defmodule Humaans.Resources.WorkflowPublication do
  @moduledoc """
  Representation of a Workflow Publication resource.
  """

  defstruct [:id, :workflow_id, :status, :created_at, :updated_at]

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
          status: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
