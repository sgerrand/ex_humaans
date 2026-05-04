defmodule Humaans.OKRs do
  @moduledoc """
  This module provides functions for listing and retrieving OKR resources in
  the Humaans API.  OKRs are read-only via the API.
  """

  use Humaans.Resource,
    path: "/okrs",
    struct: Humaans.Resources.OKR,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.OKR{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.OKR{}} | {:error, Humaans.Error.t()}
end
