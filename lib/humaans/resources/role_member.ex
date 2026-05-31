defmodule Humaans.Resources.RoleMember do
  @moduledoc """
  Representation of a Role Member resource.
  """

  defstruct [:id, :person_id, :role_id]

  use ExConstructor, :build

  def new(data), do: build(data)

  @type t :: %__MODULE__{
          id: binary | nil,
          person_id: binary | nil,
          role_id: binary | nil
        }
end
