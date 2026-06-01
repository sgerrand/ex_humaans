defmodule Humaans.EsignBulks do
  @moduledoc """
  This module provides functions for listing and retrieving e-signature
  bulk resources in the Humaans API.  Esign bulks are read-only via the
  API.
  """

  use Humaans.Resource,
    path: "/esign-bulks",
    struct: Humaans.Resources.EsignBulk,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.EsignBulk{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.EsignBulk{}} | {:error, Humaans.Error.t()}
end
