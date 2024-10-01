defmodule Humaans.Resources.CompensationType do
  @moduledoc """
  Representation of a Compensation Type resource.
  """

  defstruct [
    :id,
    :company_id,
    :name,
    :base_type,
    :created_at,
    :updated_at
  ]

  @type base_type :: :salary | :bonus | :commission | :equity | :custom
  @type t :: %__MODULE__{
          id: binary,
          company_id: binary,
          name: binary | nil,
          base_type: base_type(),
          created_at: binary,
          updated_at: binary
        }
end
