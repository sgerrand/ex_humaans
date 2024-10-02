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

  @type base_type :: :salary | :bonus | :commission | :equity | :custom
  @type t :: %__MODULE__{
          id: binary,
          person_id: binary,
          compensation_type_id: binary,
          amount: binary,
          currency: binary,
          period: binary,
          note: binary,
          effective_date: binary,
          end_date: binary,
          end_reason: binary,
          created_at: binary,
          updated_at: binary
        }
end
