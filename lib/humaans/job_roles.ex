defmodule Humaans.JobRoles do
  @moduledoc """
  This module provides functions for managing job role resources in the
  Humaans API.
  """

  use Humaans.Resource,
    path: "/job-roles",
    struct: Humaans.Resources.JobRole,
    doc_params: [
      create: ~s(%{name: "Software Engineer"}),
      update: ~s(%{name: "Senior Software Engineer"})
    ]

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, Humaans.Error.t()}
  @type list_response :: {:ok, [%Humaans.Resources.JobRole{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.JobRole{}} | {:error, Humaans.Error.t()}
end
