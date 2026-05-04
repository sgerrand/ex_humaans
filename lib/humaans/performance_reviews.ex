defmodule Humaans.PerformanceReviews do
  @moduledoc """
  This module provides functions for listing and retrieving performance
  review resources in the Humaans API.  Performance reviews are read-only
  via the API.
  """

  use Humaans.Resource,
    path: "/performance-reviews",
    struct: Humaans.Resources.PerformanceReview,
    actions: [:list, :retrieve]

  @type list_response ::
          {:ok, [%Humaans.Resources.PerformanceReview{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.PerformanceReview{}} | {:error, Humaans.Error.t()}
end
