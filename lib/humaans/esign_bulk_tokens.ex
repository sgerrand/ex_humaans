defmodule Humaans.EsignBulkTokens do
  @moduledoc """
  This module provides functions for listing and retrieving e-signature
  bulk token resources in the Humaans API.  Esign bulk tokens are
  read-only via the API.
  """

  use Humaans.Resource,
    path: "/esign-bulk-tokens",
    struct: Humaans.Resources.EsignBulkToken,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.EsignBulkToken{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.EsignBulkToken{}} | {:error, Humaans.Error.t()}
end
