defmodule Humaans.Me do
  @moduledoc """
  Singleton helper for the `/me` endpoint.

  `GET /api/me` returns the profile of the authenticated user (the human
  whose access token was used to make the request). Useful for
  startup-time "who am I" checks before issuing scoped operations.

  The response is decoded into a `Humaans.Resources.Person` struct.
  """

  alias Humaans.{Client, Resources.Person, ResponseHandler}

  @doc """
  Retrieves the authenticated user's profile.

  ## Examples

      client = Humaans.new(access_token: "your_access_token")
      {:ok, %Humaans.Resources.Person{} = me} = Humaans.Me.get(client)
  """
  @spec get(client :: map()) :: {:ok, Person.t()} | {:error, Humaans.Error.t()}
  def get(client) do
    Client.get(client, "/me")
    |> ResponseHandler.handle_resource_response(Person)
  end
end
