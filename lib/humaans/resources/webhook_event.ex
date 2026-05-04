defmodule Humaans.Resources.WebhookEvent do
  @moduledoc """
  Representation of a Webhook Event resource.
  """

  defstruct [:id, :webhook_id, :event, :data, :status, :timestamp, :created_at]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:timestamp)
    |> parse_datetime(:created_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          webhook_id: binary | nil,
          event: binary | nil,
          data: map | nil,
          status: binary | nil,
          timestamp: DateTime.t() | nil,
          created_at: DateTime.t() | nil
        }
end
