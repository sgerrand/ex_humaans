defmodule Humaans.Query do
  @moduledoc """
  Builder for Humaans API filter query parameters.

  The Humaans API (a Feathers.js application) supports filtering list
  endpoints with operator suffixes like `$in`, `$gt`, etc. Hand-encoding
  these in keyword lists is awkward in Elixir because the keys contain
  characters that don't survive atom literals, e.g.
  `["status[$in]": ["active"]]`. This module provides a small chainable
  builder so callers can express filters readably.

  ## Example

      query =
        Humaans.Query.new()
        |> Humaans.Query.eq(:companyId, "acme")
        |> Humaans.Query.in_(:status, ["active", "onboarding"])
        |> Humaans.Query.gte(:createdAt, "2025-01-01")
        |> Humaans.Query.to_params()

      Humaans.People.list(client, query)

  ## Supported operators

  * `eq/3` — exact match (no operator suffix)
  * `in_/3` — `$in` (any of)
  * `nin/3` — `$nin` (none of)
  * `gt/3` — `$gt`
  * `gte/3` — `$gte`
  * `lt/3` — `$lt`
  * `lte/3` — `$lte`

  Field names are accepted as atoms or strings. The Humaans API uses
  camelCase field names (`companyId`, `createdAt`, etc.) — pass them as
  written. Atom keys with the `$` prefix or brackets are not required:
  the builder produces them for you.

  Use `merge/2` to combine a query with other params (e.g. pagination):

      Humaans.Query.new()
      |> Humaans.Query.in_(:status, ["active"])
      |> Humaans.Query.merge("$limit": 50)
      |> Humaans.Query.to_params()
  """

  @type field :: atom() | String.t()
  @type value :: any()
  @type t :: %__MODULE__{params: [{atom(), value()}]}

  defstruct params: []

  @doc "Returns an empty query."
  @spec new() :: t()
  def new, do: %__MODULE__{}

  @doc "Adds an equality filter (`field=value`)."
  @spec eq(t(), field(), value()) :: t()
  def eq(query, field, value), do: append(query, key(field), value)

  @doc "Adds a `$in` filter (`field[$in]=value`)."
  @spec in_(t(), field(), [value()]) :: t()
  def in_(query, field, values) when is_list(values),
    do: append(query, op_key(field, "in"), values)

  @doc "Adds a `$nin` filter."
  @spec nin(t(), field(), [value()]) :: t()
  def nin(query, field, values) when is_list(values),
    do: append(query, op_key(field, "nin"), values)

  @doc "Adds a `$gt` filter."
  @spec gt(t(), field(), value()) :: t()
  def gt(query, field, value), do: append(query, op_key(field, "gt"), value)

  @doc "Adds a `$gte` filter."
  @spec gte(t(), field(), value()) :: t()
  def gte(query, field, value), do: append(query, op_key(field, "gte"), value)

  @doc "Adds a `$lt` filter."
  @spec lt(t(), field(), value()) :: t()
  def lt(query, field, value), do: append(query, op_key(field, "lt"), value)

  @doc "Adds a `$lte` filter."
  @spec lte(t(), field(), value()) :: t()
  def lte(query, field, value), do: append(query, op_key(field, "lte"), value)

  @doc """
  Merges arbitrary params (keyword list or another query) into this query.

  Useful for combining filters with pagination params.
  """
  @spec merge(t(), keyword() | t()) :: t()
  def merge(%__MODULE__{params: params} = query, %__MODULE__{params: more}) do
    %{query | params: params ++ more}
  end

  def merge(%__MODULE__{params: params} = query, more) when is_list(more) do
    %{query | params: params ++ more}
  end

  @doc """
  Returns the query as a keyword list suitable for passing as `params` to a
  resource list function.
  """
  @spec to_params(t()) :: keyword()
  def to_params(%__MODULE__{params: params}), do: params

  defp append(%__MODULE__{params: params} = query, key, value) do
    %{query | params: params ++ [{key, value}]}
  end

  defp key(field) when is_atom(field), do: field
  defp key(field) when is_binary(field), do: String.to_atom(field)

  defp op_key(field, op) do
    name = field |> to_string() |> Kernel.<>("[$#{op}]")
    String.to_atom(name)
  end
end
