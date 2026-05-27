defmodule Humaans.WorkflowFormResponses do
  @moduledoc """
  This module provides functions for retrieving workflow form response
  resources in the Humaans API.  Workflow form responses are retrieve-only
  via the API.
  """

  use Humaans.Resource,
    path: "/workflow-form-responses",
    struct: Humaans.Resources.WorkflowFormResponse,
    actions: [:retrieve]

  @type response ::
          {:ok, %Humaans.Resources.WorkflowFormResponse{}} | {:error, Humaans.Error.t()}
end
