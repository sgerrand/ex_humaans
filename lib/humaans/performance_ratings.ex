defmodule Humaans.PerformanceRatings do
  @moduledoc """
  This module provides functions for retrieving performance rating
  resources in the Humaans API.  Performance ratings are retrieve-only via
  the API.
  """

  use Humaans.Resource,
    path: "/performance-ratings",
    struct: Humaans.Resources.PerformanceRating,
    actions: [:retrieve]

  @type response :: {:ok, %Humaans.Resources.PerformanceRating{}} | {:error, Humaans.Error.t()}
end
