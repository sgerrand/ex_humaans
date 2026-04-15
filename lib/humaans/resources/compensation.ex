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

  defp parse_date(struct, field) do
    case Map.get(struct, field) do
      nil ->
        struct

      "" ->
        struct

      value when is_binary(value) ->
        case Date.from_iso8601(value) do
          {:ok, date} -> Map.put(struct, field, date)
          {:error, _} -> struct
        end

      _ ->
        struct
    end
  end

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
