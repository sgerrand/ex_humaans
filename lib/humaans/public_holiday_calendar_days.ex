defmodule Humaans.PublicHolidayCalendarDays do
  @moduledoc """
  This module provides functions for managing public holiday calendar day
  resources in the Humaans API.  Note that the API does not support
  deletion.
  """

  use Humaans.Resource,
    path: "/public-holiday-calendar-days",
    struct: Humaans.Resources.PublicHolidayCalendarDay,
    actions: [:list, :retrieve, :create, :update],
    doc_params: [
      create: ~s(%{publicHolidayCalendarId: "cal_abc", publicHolidayId: "ph_abc"}),
      update: ~s(%{publicHolidayId: "ph_def"})
    ]

  @type list_response ::
          {:ok, [%Humaans.Resources.PublicHolidayCalendarDay{}]} | {:error, Humaans.Error.t()}
  @type response ::
          {:ok, %Humaans.Resources.PublicHolidayCalendarDay{}} | {:error, Humaans.Error.t()}
end
