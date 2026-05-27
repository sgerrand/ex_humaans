defmodule Humaans.RequestReviews do
  @moduledoc """
  This module provides functions for listing and retrieving request review
  resources in the Humaans API.  Request reviews are read-only via the API.
  """

  use Humaans.Resource,
    path: "/request-reviews",
    struct: Humaans.Resources.RequestReview,
    actions: [:list, :retrieve]

  @type list_response :: {:ok, [%Humaans.Resources.RequestReview{}]} | {:error, Humaans.Error.t()}
  @type response :: {:ok, %Humaans.Resources.RequestReview{}} | {:error, Humaans.Error.t()}
end
