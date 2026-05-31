defmodule Humaans.Resources.Role do
  @moduledoc """
  Representation of a Role resource.
  """

  defstruct [:id, :name]

  use ExConstructor, :build

  def new(data), do: build(data)

  @type t :: %__MODULE__{
          id: binary | nil,
          name: binary | nil
        }
end
