defmodule Humaans.PerformanceSummaries do
  @moduledoc """
  This module provides functions for retrieving performance summary
  resources in the Humaans API.  Performance summaries are retrieve-only
  via the API.
  """

  use Humaans.Resource,
    path: "/performance-summaries",
    struct: Humaans.Resources.PerformanceSummary,
    actions: [:retrieve]

  @type response :: {:ok, %Humaans.Resources.PerformanceSummary{}} | {:error, Humaans.Error.t()}
end
