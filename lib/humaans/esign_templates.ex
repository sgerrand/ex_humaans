defmodule Humaans.EsignTemplates do
  @moduledoc """
  This module provides functions for listing and retrieving e-signature
  template resources in the Humaans API.  Esign templates are read-only
  via the API.
  """

  use Humaans.Resource,
    path: "/esign-templates",
    struct: Humaans.Resources.EsignTemplate,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.EsignTemplate{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.EsignTemplate{}} | {:error, Humaans.Error.t()}
end
