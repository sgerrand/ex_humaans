defmodule Humaans.RequestActivityLogs do
  @moduledoc """
  This module provides functions for listing and retrieving request activity
  log resources in the Humaans API.  Request activity logs are read-only
  via the API.
  """

  use Humaans.Resource,
    path: "/request-activity-logs",
    struct: Humaans.Resources.RequestActivityLog,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.RequestActivityLog{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.RequestActivityLog{}} | {:error, Humaans.Error.t()}
end
