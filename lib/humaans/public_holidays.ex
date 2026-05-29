defmodule Humaans.PublicHolidays do
  @moduledoc """
  This module provides functions for listing public holiday resources in the
  Humaans API.  Public holidays are read-only via the API.
  """

  use Humaans.Resource,
    path: "/public-holidays",
    struct: Humaans.Resources.PublicHoliday,
    actions: [:list]

  @type list_response :: {:ok, [%Humaans.Resources.PublicHoliday{}]} | {:error, Humaans.Error.t()}
end
