defmodule Humaans.HTTPClient.Behaviour do
  @moduledoc """
  Behaviour for Humaans HTTP clients.
  """

  @callback request(client :: Humaans.t(), opts :: Keyword.t()) :: {:ok, map()} | {:error, map()}
end
