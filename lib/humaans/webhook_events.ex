defmodule Humaans.WebhookEvents do
  @moduledoc """
  This module provides functions for listing and retrieving webhook event
  resources in the Humaans API.  Webhook events are read-only via the API.
  """

  use Humaans.Resource,
    path: "/webhook-events",
    struct: Humaans.Resources.WebhookEvent,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.WebhookEvent{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.WebhookEvent{}} | {:error, Humaans.Error.t()}
end
