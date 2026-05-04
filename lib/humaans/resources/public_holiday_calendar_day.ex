defmodule Humaans.Resources.PublicHolidayCalendarDay do
  @moduledoc """
  Representation of a Public Holiday Calendar Day resource.
  """

  defstruct [
    :id,
    :public_holiday_calendar_id,
    :public_holiday_id,
    :created_at,
    :updated_at
  ]

  use ExConstructor, :build

  import Humaans.Resources.Timestamps

  def new(data) do
    data
    |> build()
    |> parse_datetime(:created_at)
    |> parse_datetime(:updated_at)
  end

  @type t :: %__MODULE__{
          id: binary | nil,
          public_holiday_calendar_id: binary | nil,
          public_holiday_id: binary | nil,
          created_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }
end
