defmodule Humaans.RequestTypes do
  @moduledoc """
  This module provides functions for listing and retrieving request type
  resources in the Humaans API.  Request types are read-only via the API.
  """

  use Humaans.Resource,
    path: "/request-types",
    struct: Humaans.Resources.RequestType,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.RequestType{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.RequestType{}} | {:error, Humaans.Error.t()}
end
