defmodule Humaans.RequestComments do
  @moduledoc """
  This module provides functions for listing and retrieving request comment
  resources in the Humaans API.  Request comments are read-only via the API.
  """

  use Humaans.Resource,
    path: "/request-comments",
    struct: Humaans.Resources.RequestComment,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.RequestComment{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.RequestComment{}} | {:error, Humaans.Error.t()}
end
