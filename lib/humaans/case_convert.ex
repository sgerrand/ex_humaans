defmodule Humaans.CaseConvert do
  @moduledoc """
  Internal helper that converts snake_case keys to camelCase before sending
  request bodies to the Humaans API.

  Responses come back camelCase and are converted to snake_case by
  `ExConstructor` on the resource structs. This module closes the loop on
  the request side: callers can write `%{first_name: "Jane"}` instead of
  `%{firstName: "Jane"}` and have the value reach the wire correctly.

  Already-camelCase keys are passed through unchanged, so existing code
  that uses camelCase keys continues to work.
  """

  @doc """
  Converts top-level keys of a map or keyword list from snake_case to
  camelCase. Atom keys produce atom keys; string keys produce string keys.
  Non-map, non-list values are returned unchanged.
  """
  @spec to_camel_case_keys(any()) :: any()
  def to_camel_case_keys(map) when is_map(map) and not is_struct(map) do
    Map.new(map, fn {k, v} -> {to_camel(k), v} end)
  end

  def to_camel_case_keys(list) when is_list(list) do
    Enum.map(list, fn
      {k, v} -> {to_camel(k), v}
      other -> other
    end)
  end

  def to_camel_case_keys(other), do: other

  defp to_camel(key) when is_atom(key) do
    key |> Atom.to_string() |> camelize() |> String.to_atom()
  end

  defp to_camel(key) when is_binary(key), do: camelize(key)
  defp to_camel(other), do: other

  defp camelize(string) do
    [head | tail] = String.split(string, "_")
    head <> Enum.map_join(tail, "", &capitalize_first/1)
  end

  defp capitalize_first(<<c, rest::binary>>) when c in ?a..?z, do: <<c - 32, rest::binary>>
  defp capitalize_first(other), do: other
end
