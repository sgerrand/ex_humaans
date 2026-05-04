defmodule Humaans.PerformanceCycles do
  @moduledoc """
  This module provides functions for listing and retrieving performance
  cycle resources in the Humaans API.  Performance cycles are read-only
  via the API.
  """

  use Humaans.Resource,
    path: "/performance-cycles",
    struct: Humaans.Resources.PerformanceCycle,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.PerformanceCycle{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.PerformanceCycle{}} | {:error, Humaans.Error.t()}
end
