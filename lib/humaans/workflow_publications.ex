defmodule Humaans.WorkflowPublications do
  @moduledoc """
  This module provides functions for retrieving workflow publication
  resources in the Humaans API.  Workflow publications are retrieve-only
  via the API.
  """

  use Humaans.Resource,
    path: "/workflow-publications",
    struct: Humaans.Resources.WorkflowPublication,
    actions: [:retrieve]

  @type response ::
          {:ok, %Humaans.Resources.WorkflowPublication{}} | {:error, Humaans.Error.t()}
end
