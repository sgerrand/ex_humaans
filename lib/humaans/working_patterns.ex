defmodule Humaans.WorkingPatterns do
  @moduledoc """
  This module provides functions for managing working pattern resources in
  the Humaans API.
  """

  use Humaans.Resource,
    path: "/working-patterns",
    struct: Humaans.Resources.WorkingPattern,
    doc_params: [
      create: ~s(%{name: "Mon-Fri 9-5"}),
      update: ~s(%{name: "Mon-Thu 9-5"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response ::
          {:ok, [%Humaans.Resources.WorkingPattern{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.WorkingPattern{}} | {:error, Humaans.Error.t()}
end
