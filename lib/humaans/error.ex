defmodule Humaans.Error do
  @moduledoc """
  Represents an error returned by the Humaans API or HTTP layer.

  ## Error types

  * `:api_error` - The API returned a non-2xx HTTP status code. The `status`
    field contains the HTTP status code and `body` contains the parsed response
    body. The Humaans API's structured error envelope (`code`, `name`,
    `message`, `issues`) is also extracted onto top-level fields when present.
  * `:network_error` - A transport-level error occurred before a response was
    received (e.g. connection refused, DNS failure). The `reason` field contains
    the underlying error.

  ## Structured API error fields

  When the API returns a structured error body, the following fields are
  populated:

  * `code` - Short error code, e.g. `"ValidationError"`, `"NotFound"`.
  * `name` - Human-readable error name.
  * `api_message` - The API's error message string. (Named to avoid shadowing
    the `Exception.message/1` callback, which returns a formatted display
    string.)
  * `issues` - List of field-level validation errors (each typically a map with
    `path` and `message` keys). `nil` if not present.

  The raw `body` is always retained for forward-compatibility with undocumented
  fields.

  ## Examples

      case Humaans.People.retrieve(client, "missing-id") do
        {:ok, person} ->
          person

        {:error, %Humaans.Error{type: :api_error, status: 404}} ->
          :not_found

        {:error, %Humaans.Error{type: :api_error, status: 422, issues: issues}}
        when is_list(issues) ->
          {:invalid, issues}

        {:error, %Humaans.Error{type: :api_error, status: 401}} ->
          :unauthorized

        {:error, %Humaans.Error{type: :network_error, reason: reason}} ->
          {:network_failure, reason}
      end

  """

  @type error_type :: :api_error | :network_error

  @type issue :: %{optional(String.t()) => any()}

  @type t :: %__MODULE__{
          type: error_type(),
          status: non_neg_integer() | nil,
          body: map() | nil,
          reason: any(),
          code: String.t() | nil,
          name: String.t() | nil,
          api_message: String.t() | nil,
          issues: [issue()] | nil
        }

  defexception [:type, :status, :body, :reason, :code, :name, :api_message, :issues]

  @impl Exception
  def message(%__MODULE__{type: :api_error, status: status, api_message: msg})
      when is_binary(msg) do
    "Humaans API error: HTTP #{status} - #{msg}"
  end

  def message(%__MODULE__{type: :api_error, status: status, body: body}) do
    "Humaans API error: HTTP #{status} - #{inspect(body)}"
  end

  def message(%__MODULE__{type: :network_error, reason: reason}) do
    "Humaans network error: #{inspect(reason)}"
  end

  @doc """
  Builds an `:api_error` from an HTTP status and response body, extracting
  the API's structured error fields when present.
  """
  @spec from_api_response(non_neg_integer(), any()) :: t()
  def from_api_response(status, body) when is_map(body) do
    %__MODULE__{
      type: :api_error,
      status: status,
      body: body,
      code: extract_string(body, "code"),
      name: extract_string(body, "name"),
      api_message: extract_string(body, "message"),
      issues: extract_issues(body)
    }
  end

  def from_api_response(status, body) do
    %__MODULE__{type: :api_error, status: status, body: body}
  end

  defp extract_string(body, key) do
    case Map.get(body, key) do
      v when is_binary(v) -> v
      _ -> nil
    end
  end

  defp extract_issues(body) do
    case Map.get(body, "issues") do
      v when is_list(v) -> v
      _ -> nil
    end
  end
end
