defmodule Humaans.Resources.Webhook do
  @moduledoc """
  Representation of a Webhook resource.
  """

  defstruct [:id, :company_id, :url, :events, :created_at, :updated_at]

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
          company_id: binary | nil,
          url: binary | nil,
          events: [String.t()] | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
