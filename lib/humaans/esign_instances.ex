defmodule Humaans.EsignInstances do
  @moduledoc """
  This module provides functions for listing and retrieving e-signature
  instance resources in the Humaans API.  Esign instances are read-only
  via the API.
  """

  use Humaans.Resource,
    path: "/esign-instances",
    struct: Humaans.Resources.EsignInstance,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.EsignInstance{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.EsignInstance{}} | {:error, Humaans.Error.t()}
end
