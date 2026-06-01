defmodule Humaans.WorkflowDependencies do
  @moduledoc """
  This module provides functions for retrieving workflow dependency resources
  in the Humaans API.  Workflow dependencies are retrieve-only via the API.
  """

  use Humaans.Resource,
    path: "/workflow-dependencies",
    struct: Humaans.Resources.WorkflowDependency,
    actions: [:retrieve]

  @type response ::
          {:ok, %Humaans.Resources.WorkflowDependency{}} | {:error, Humaans.Error.t()}
end
