defmodule Humaans.PerformanceInstances do
  @moduledoc """
  This module provides functions for listing and retrieving performance
  instance resources in the Humaans API.  Performance instances are
  read-only via the API.
  """

  use Humaans.Resource,
    path: "/performance-instances",
    struct: Humaans.Resources.PerformanceInstance,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.PerformanceInstance{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.PerformanceInstance{}} | {:error, Humaans.Error.t()}
end
