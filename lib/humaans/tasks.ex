defmodule Humaans.Tasks do
  @moduledoc """
  This module provides functions for listing and retrieving task resources
  in the Humaans API.  Tasks are read-only via the API.
  """

  use Humaans.Resource,
    path: "/tasks",
    struct: Humaans.Resources.Task,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.Task{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.Task{}} | {:error, Humaans.Error.t()}
end
