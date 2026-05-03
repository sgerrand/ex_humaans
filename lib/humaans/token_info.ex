defmodule Humaans.TokenInfo do
  @moduledoc """
  Singleton helper for the `/token-info` endpoint.

  `GET /api/token-info` returns metadata about the access token used for
  the request, including its scopes and capabilities. Useful for verifying
  that a token has the permissions an integration needs before attempting
  scoped operations.

  The response is returned as a raw map of the API's JSON payload —
  unlike resource endpoints, the shape is not modelled as a struct
  because the field set is small and largely tooling-only.
  """

  alias Humaans.{Client, ResponseHandler}

  @doc """
  Retrieves metadata for the current access token.

  ## Examples

      client = Humaans.new(access_token: "your_access_token")
      {:ok, info} = Humaans.TokenInfo.get(client)

      info["scopes"]   # => ["private:read", "private:write", ...]
      info["personId"] # => "person_abc"
  """
  @spec get(client :: map()) :: {:ok, map()} | {:error, Humaans.Error.t()}
  def get(client) do
    Client.get(client, "/token-info")
    |> ResponseHandler.handle_response(& &1)
  end
end
