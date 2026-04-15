defmodule Humaans.CompensationTypes do
  @moduledoc """
  This module provides functions for managing compensation type resources in the
  Humaans API. Compensation types are used to define different categories of
  compensation such as salary, bonus, commission, etc.
  """

  use Humaans.Resource,
    path: "/compensation-types",
    struct: Humaans.Resources.CompensationType,
    doc_params: [
      create: ~s(%{name: "Annual Bonus", baseType: "variable"}),
      update: ~s(%{name: "Performance Bonus"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.CompensationType{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.CompensationType{}} | {:error, Humaans.Error.t()}
end
