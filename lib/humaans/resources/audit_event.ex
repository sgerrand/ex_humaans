defmodule Humaans.Resources.AuditEvent do
  @moduledoc """
  Representation of an Audit Event resource.
  """

  defstruct [
    :id,
    :company_id,
    :seq,
    :ts,
    :request,
    :action,
    :actor,
    :entity,
    :subject
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:ts)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          company_id: binary | nil,
          seq: binary | nil,
          ts: DateTime.t() | nil,
          request: map | nil,
          action: binary | nil,
          actor: map | nil,
          entity: map | nil,
          subject: map | nil
        }
end
