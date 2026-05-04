defmodule Humaans.Resources.RolePermission do
  @moduledoc """
  Representation of a Role Permission resource.
  """

  defstruct [:id, :name, :role_id]

  use ExConstructor, :build

  def new(data), do: build(data)

  @type t :: %__MODULE__{
          id: binary | nil,
          name: binary | nil,
          role_id: binary | nil
        }
end
