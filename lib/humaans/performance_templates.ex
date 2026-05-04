defmodule Humaans.PerformanceTemplates do
  @moduledoc """
  This module provides functions for listing and retrieving performance
  template resources in the Humaans API.  Performance templates are
  read-only via the API.
  """

  use Humaans.Resource,
    path: "/performance-templates",
    struct: Humaans.Resources.PerformanceTemplate,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.PerformanceTemplate{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.PerformanceTemplate{}} | {:error, Humaans.Error.t()}
end
