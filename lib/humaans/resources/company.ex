defmodule Humaans.Resources.Company do
  @moduledoc """
  Representation of a Company resource.
  """

  defstruct [
    :id,
    :name,
    :domains,
    :trial_end_date,
    :status,
    :payment_status,
    :package,
    :is_timesheet_enabled,
    :autogenerate_employee_id,
    :autogenerate_employee_id_for_new_hires,
    :next_employee_id,
    :created_at,
    :updated_at
  ]

  use ExConstructor

  @type payment_status :: :requires_action | :past_due | :ok
  @type status :: :terms | :trialing | :expired | :active | :suspended
  @type t :: %__MODULE__{
          id: binary | nil,
          name: binary | nil,
          domains: [String.t()] | nil,
          trial_end_date: binary | nil,
          status: status(),
          payment_status: payment_status(),
          package: binary | nil,
          is_timesheet_enabled: boolean,
          autogenerate_employee_id: boolean,
          autogenerate_employee_id_for_new_hires: boolean,
          next_employee_id: pos_integer,
          created_at: binary | nil,
          updated_at: binary | nil
        }
end
