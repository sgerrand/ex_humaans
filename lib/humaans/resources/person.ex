defmodule Humaans.Resources.Person do
  @moduledoc """
  Representation of a Person resource.
  """

  defstruct [
    :id,
    :company_id,
    :first_name,
    :middle_name,
    :last_name,
    :preferred_name,
    :email,
    :location_id,
    :remote_city,
    :remote_region_code,
    :remote_country_code,
    :remote_timezone,
    :personal_email,
    :phone_number,
    :formatted_phone_number,
    :personal_phone_number,
    :formatted_personal_phone_number,
    :gender,
    :birthday,
    :profile_photo_id,
    :profile_photo,
    :nationality,
    :nationalities,
    :spoken_languages,
    :dietary_preference,
    :food_allergies,
    :address,
    :city,
    :state,
    :postcode,
    :country_code,
    :country,
    :bio,
    :linked_in,
    :twitter,
    :github,
    :employment_start_date,
    :first_working_day,
    :employment_end_date,
    :last_working_day,
    :probation_end_date,
    :turnover_impact,
    :working_days,
    :public_holiday_calendar_id,
    :leaving_reason,
    :leaving_note,
    :leaving_file_id,
    :contract_type,
    :employee_id,
    :tax_id,
    :tax_code,
    :teams,
    :status,
    :is_verified,
    :is_work_email_hidden,
    :calendar_feed_token,
    :role,
    :seen_documents_at,
    :source,
    :source_id,
    :timezone,
    :payroll_provider,
    :is_birthday_hidden,
    :demo,
    :created_at,
    :updated_at
  ]

  use ExConstructor

  @typep leaving_reason :: :dismissed | :resigned | :redundancy | :contract_ended | :other | nil
  @typep status :: :active | :offboarded | :new_hire
  @typep team :: %{name: String.t()}
  @typep working_day :: %{day: String.t()}
  @type t :: %__MODULE__{
          id: binary,
          company_id: binary,
          first_name: binary,
          middle_name: binary | nil,
          last_name: binary,
          preferred_name: binary | nil,
          email: binary,
          location_id: binary,
          remote_city: binary | nil,
          remote_region_code: binary | nil,
          remote_country_code: binary | nil,
          remote_timezone: binary | nil,
          personal_email: binary,
          phone_number: binary | nil,
          formatted_phone_number: binary | nil,
          personal_phone_number: binary | nil,
          formatted_personal_phone_number: binary | nil,
          gender: binary,
          birthday: binary,
          profile_photo_id: binary,
          profile_photo: map | nil,
          nationality: binary,
          nationalities: [String.t()],
          spoken_languages: [String.t()],
          dietary_preference: binary,
          food_allergies: [String.t()],
          address: binary,
          city: binary,
          state: binary,
          postcode: binary,
          country_code: binary,
          country: binary,
          bio: binary,
          linked_in: binary,
          twitter: binary,
          github: binary,
          employment_start_date: binary,
          first_working_day: binary,
          employment_end_date: binary | nil,
          last_working_day: binary | nil,
          probation_end_date: binary | nil,
          turnover_impact: binary | nil,
          working_days: [working_day()],
          public_holiday_calendar_id: binary,
          leaving_reason: leaving_reason(),
          leaving_note: binary | nil,
          leaving_file_id: binary | nil,
          contract_type: binary | nil,
          employee_id: binary | nil,
          tax_id: binary | nil,
          tax_code: binary | nil,
          teams: [team()],
          status: status(),
          is_verified: boolean,
          is_work_email_hidden: boolean,
          calendar_feed_token: binary | nil,
          role: binary,
          seen_documents_at: binary | nil,
          source: binary | nil,
          source_id: binary | nil,
          timezone: binary,
          payroll_provider: binary | nil,
          is_birthday_hidden: boolean,
          demo: boolean,
          created_at: binary,
          updated_at: binary
        }
end