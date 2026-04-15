defmodule Humaans.Resources.Compensation do
  @moduledoc """
  Representation of a Compensation resource.
  """

  defstruct [
    :id,
    :person_id,
    :compensation_type_id,
    :amount,
    :currency,
    :period,
    :note,
    :effective_date,
    :end_date,
    :end_reason,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_date(:effective_date)
    |> parse_date(:end_date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type base_type :: :salary | :bonus | :commission | :equity | :custom
  @type t :: %__MODULE__{
          id: binary,
          person_id: binary,
          compensation_type_id: binary,
          amount: binary,
          currency: binary,
          period: binary,
          note: binary,
          effective_date: Date.t() | nil,
          end_date: Date.t() | nil,
          end_reason: binary,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
