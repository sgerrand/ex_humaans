defmodule Humaans.CaseConvert do
  @moduledoc """
  Internal helper that converts snake_case keys to camelCase before sending
  request bodies to the Humaans API.

  Responses come back camelCase and are converted to snake_case by
  `ExConstructor` on the resource structs. This module closes the loop on
  the request side: callers can write `%{first_name: "Jane"}` instead of
  `%{firstName: "Jane"}` and have the value reach the wire correctly.

  Already-camelCase keys are passed through unchanged (post-conversion to
  string keys, see below).

  ## Output keys are always strings

  Input atom keys are converted to string keys in the output. This avoids
  creating new atoms at runtime — atoms are not garbage-collected and
  untrusted, high-cardinality keys could otherwise exhaust the atom table.
  The same guidance applies in `Humaans.Query`. Req JSON-encodes
  string-keyed maps transparently, so callers don't need to do anything
  different.

  Keyword list inputs are converted to string-keyed maps for the same
  reason and because keyword lists structurally require atom keys.

  ## Collisions

  When two distinct input keys normalize to the same camelCase string
  (e.g. `%{first_name: 1, firstName: 2}`), `ArgumentError` is raised
  rather than silently dropping a field.
  """

  @doc """
  Converts top-level keys of a map or keyword list from snake_case to
  camelCase. Output keys are always strings (see module doc).
  Non-map, non-list values are returned unchanged.

  Raises `ArgumentError` when two distinct input keys normalize to the
  same camelCase string.
  """
  @spec to_camel_case_keys(any()) :: any()
  def to_camel_case_keys(map) when is_map(map) and not is_struct(map) do
    map_to_camel(map)
  end

  def to_camel_case_keys(list) when is_list(list) do
    if keyword_list?(list) do
      list |> Map.new() |> map_to_camel()
    else
      list
    end
  end

  def to_camel_case_keys(other), do: other

  defp map_to_camel(map) do
    Enum.reduce(map, %{}, fn {k, v}, acc ->
      new_k = to_camel_key(k)

      if convertible?(k) and Map.has_key?(acc, new_k) do
        raise ArgumentError,
              "Humaans.CaseConvert: multiple input keys normalize to #{inspect(new_k)}"
      end

      Map.put(acc, new_k, v)
    end)
  end

  defp keyword_list?([]), do: false
  defp keyword_list?(list), do: Enum.all?(list, fn el -> match?({k, _} when is_atom(k), el) end)

  defp convertible?(k), do: is_atom(k) or is_binary(k)

  defp to_camel_key(key) when is_atom(key), do: key |> Atom.to_string() |> camelize()
  defp to_camel_key(key) when is_binary(key), do: camelize(key)
  defp to_camel_key(other), do: other

  defp camelize(string) do
    [head | tail] = String.split(string, "_")
    head <> Enum.map_join(tail, "", &capitalize_first/1)
  end

  defp capitalize_first(<<c, rest::binary>>) when c in ?a..?z, do: <<c - 32, rest::binary>>
  defp capitalize_first(other), do: other
end
