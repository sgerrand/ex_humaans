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

  use ExConstructor, :build

  def new(data) do
    data
    |> build()
    |> parse_date(:trial_end_date)
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type payment_status :: :requires_action | :past_due | :ok
  @type status :: :terms | :trialing | :expired | :active | :suspended
  @type t :: %__MODULE__{
          id: binary | nil,
          name: binary | nil,
          domains: [String.t()] | nil,
          trial_end_date: Date.t() | nil,
          status: status(),
          payment_status: payment_status(),
          package: binary | nil,
          is_timesheet_enabled: boolean,
          autogenerate_employee_id: boolean,
          autogenerate_employee_id_for_new_hires: boolean,
          next_employee_id: pos_integer,
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
