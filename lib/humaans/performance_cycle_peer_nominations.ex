defmodule Humaans.PerformanceCyclePeerNominations do
  @moduledoc """
  This module provides functions for retrieving performance cycle peer
  nomination resources in the Humaans API.  Peer nominations are
  retrieve-only via the API.
  """

  use Humaans.Resource,
    path: "/performance-cycle-peer-nominations",
    struct: Humaans.Resources.PerformanceCyclePeerNomination,
    actions: [:retrieve]

  @type response ::
          {:ok, %Humaans.Resources.PerformanceCyclePeerNomination{}}
          | {:error, Humaans.Error.t()}
end
