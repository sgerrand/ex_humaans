defmodule Humaans.Resources.WorkflowSlackAction do
  @moduledoc """
  Representation of a Workflow Slack Action resource.
  """

  defstruct [:id, :workflow_id, :channel, :message, :created_at, :updated_at]

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
          channel: binary | nil,
          message: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
