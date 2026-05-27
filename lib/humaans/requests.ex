defmodule Humaans.Requests do
  @moduledoc """
  This module provides functions for listing and retrieving request
  resources in the Humaans API.  Requests are read-only via the API.
  """

  use Humaans.Resource,
    path: "/requests",
    struct: Humaans.Resources.Request,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.Request{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Request{}} | {:error, Humaans.Error.t()}
end
