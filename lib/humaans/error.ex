defmodule Humaans.Error do
  @moduledoc """
  Represents an error returned by the Humaans API or HTTP layer.

  ## Error types

  * `:api_error` - The API returned a non-2xx HTTP status code. The `status`
    field contains the HTTP status code and `body` contains the parsed response
    body.
  * `:network_error` - A transport-level error occurred before a response was
    received (e.g. connection refused, DNS failure). The `reason` field contains
    the underlying error.

  ## Examples

      case Humaans.People.retrieve(client, "missing-id") do
        {:ok, person} ->
          person

        {:error, %Humaans.Error{type: :api_error, status: 404}} ->
          :not_found

        {:error, %Humaans.Error{type: :api_error, status: 401}} ->
          :unauthorized

        {:error, %Humaans.Error{type: :network_error, reason: reason}} ->
          {:network_failure, reason}
      end

  """

  @type error_type :: :api_error | :network_error

  @type t :: %__MODULE__{
          type: error_type(),
          status: non_neg_integer() | nil,
          body: map() | nil,
          reason: any()
        }

  defexception [:type, :status, :body, :reason]

  @impl Exception
  def message(%__MODULE__{type: :api_error, status: status, body: body}) do
    "Humaans API error: HTTP #{status} - #{inspect(body)}"
  end

  def message(%__MODULE__{type: :network_error, reason: reason}) do
    "Humaans network error: #{inspect(reason)}"
  end
end
