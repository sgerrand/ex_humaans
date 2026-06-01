defmodule Humaans.WorkflowStats do
  @moduledoc """
  This module provides functions for retrieving workflow stat resources in
  the Humaans API.  Workflow stats are retrieve-only via the API.
  """

  use Humaans.Resource,
    path: "/workflow-stats",
    struct: Humaans.Resources.WorkflowStat,
    actions: [:retrieve]

  @type response :: {:ok, %Humaans.Resources.WorkflowStat{}} | {:error, Humaans.Error.t()}
end
