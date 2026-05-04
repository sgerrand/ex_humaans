defmodule Humaans.TimeAwayPolicies do
  @moduledoc """
  This module provides functions for managing time away policy resources in
  the Humaans API.
  """

  use Humaans.Resource,
    path: "/time-away-policies",
    struct: Humaans.Resources.TimeAwayPolicy,
    doc_params: [
      create: ~s(%{name: "UK Holiday Policy"}),
      update: ~s(%{name: "Updated Holiday Policy"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.TimeAwayPolicy{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.TimeAwayPolicy{}} | {:error, Humaans.Error.t()}
end
