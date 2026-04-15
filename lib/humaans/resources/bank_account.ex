defmodule Humaans.Resources.BankAccount do
  @moduledoc """
  Representation of a Bank Account resource.
  """

  defstruct [
    :id,
    :person_id,
    :bank_name,
    :name_on_account,
    :account_number,
    :swift_code,
    :sort_code,
    :routing_number,
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

  @type t :: %__MODULE__{
          id: binary | nil,
          person_id: binary | nil,
          bank_name: binary | nil,
          name_on_account: binary | nil,
          account_number: binary | nil,
          swift_code: binary | nil,
          sort_code: binary | nil,
          routing_number: binary | nil,
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
