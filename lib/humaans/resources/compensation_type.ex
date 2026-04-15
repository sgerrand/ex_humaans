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

  use ExConstructor, :build

  def new(data) do
    data
    |> build()
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type base_type :: :salary | :bonus | :commission | :equity | :custom
  @type t :: %__MODULE__{
          id: binary,
          company_id: binary,
          name: binary | nil,
          base_type: base_type(),
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  defp parse_datetime(struct, field) do
    case Map.get(struct, field) do
      nil ->
        struct

      "" ->
        struct

      value when is_binary(value) ->
        case DateTime.from_iso8601(value) do
          {:ok, datetime, _offset} -> Map.put(struct, field, datetime)
          {:error, _} -> struct
        end

      _ ->
        struct
    end
  end
end
