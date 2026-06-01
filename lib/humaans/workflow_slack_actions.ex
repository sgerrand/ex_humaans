defmodule Humaans.WorkflowSlackActions do
  @moduledoc """
  This module provides functions for retrieving workflow Slack action
  resources in the Humaans API.  Workflow Slack actions are retrieve-only
  via the API.
  """

  use Humaans.Resource,
    path: "/workflow-slack-actions",
    struct: Humaans.Resources.WorkflowSlackAction,
    actions: [:retrieve]

  @type response ::
          {:ok, %Humaans.Resources.WorkflowSlackAction{}} | {:error, Humaans.Error.t()}
end
