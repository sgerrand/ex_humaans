defmodule Humaans.AuditEvents do
  @moduledoc """
  This module provides functions for retrieving audit event resources in the
  Humaans API.  Audit events are retrieve-only via the API; there is no
  list endpoint.
  """

  use Humaans.Resource,
    path: "/audit-events",
    struct: Humaans.Resources.AuditEvent,
    actions: [:retrieve]

  @type response :: {:ok, %Humaans.Resources.AuditEvent{}} | {:error, Humaans.Error.t()}
end
