defmodule Humaans.EsignBulkRecipients do
  @moduledoc """
  This module provides functions for listing and retrieving e-signature
  bulk recipient resources in the Humaans API.  Esign bulk recipients are
  read-only via the API.
  """

  use Humaans.Resource,
    path: "/esign-bulk-recipients",
    struct: Humaans.Resources.EsignBulkRecipient,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.EsignBulkRecipient{}]} | {:error, Humaans.Error.t()}
  @type response ::
          {:ok, %Humaans.Resources.EsignBulkRecipient{}} | {:error, Humaans.Error.t()}
end
