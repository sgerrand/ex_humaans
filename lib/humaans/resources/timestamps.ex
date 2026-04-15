defmodule Humaans.Resources.Timestamps do
  @moduledoc false

  def parse_date(struct, field) do
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

  def parse_datetime(struct, field) do
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
