defmodule Humaans.PublicHolidayCalendars do
  @moduledoc """
  This module provides functions for listing public holiday calendar
  resources in the Humaans API.  Public holiday calendars are read-only via
  the API.
  """

  use Humaans.Resource,
    path: "/public-holiday-calendars",
    struct: Humaans.Resources.PublicHolidayCalendar,
    actions: [:list]

  @type list_response ::
          {:ok, [%Humaans.Resources.PublicHolidayCalendar{}]} | {:error, Humaans.Error.t()}
end
