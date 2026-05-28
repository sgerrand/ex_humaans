defmodule Humaans do
  @moduledoc """
  A HTTP client for the Humaans API.

  This library provides an interface to the Humaans API, allowing you to manage
  people, companies, bank accounts, compensations, timesheet entries, and more.
  It follows a modular design where the main `Humaans` module serves as the
  entry point for creating clients, while specific resource modules handle
  operations for each resource type.

  [Humaans API Documentation](https://docs.humaans.io/api/)

  ## Architecture

  The library follows a layered architecture:
  - `Humaans` - Main module that creates configured client instances
  - Resource modules (`People`, `Companies`, etc.) - Handle operations specific to each resource type
  - HTTP client - Abstracts the HTTP communication details in a configurable manner

  ## Configuration Options

  When creating a client with `Humaans.new/1`, you can configure:

  * `:access_token` - Your Humaans API access token (required)
  * `:base_url` - The base URL for API requests (defaults to "https://app.humaans.io/api")
  * `:http_client` - The HTTP client module to use (defaults to `Humaans.HTTPClient.Req`)
  * `:req_options` - Keyword list merged into the default `Req` client config
    (e.g. `[connect_options: [timeout: 30_000], retry: :transient]`). Has no
    effect when `:http_client` is overridden.

  ## Examples

      # Create a default client
      client = Humaans.new(access_token: "some-access-token")

      # Create a client with custom base URL
      client = Humaans.new(
        access_token: "some-access-token",
        base_url: "https://custom-instance.humaans.io/api"
      )

      # Create a client with custom HTTP client
      client = Humaans.new(
        access_token: "some-access-token",
        http_client: MyCustomHTTPClient
      )

      # Tune timeouts and retries on the default Req client
      client = Humaans.new(
        access_token: "some-access-token",
        req_options: [connect_options: [timeout: 30_000], retry: :transient]
      )

      # Make API calls
      {:ok, people} = Humaans.People.list(client)
      {:ok, person} = Humaans.People.retrieve(client, "123")
      {:ok, companies} = Humaans.Companies.list(client)

      # Create a new person
      person_params = %{
        "firstName" => "Jane",
        "lastName" => "Doe",
        "email" => "jane.doe@example.com"
      }
      {:ok, new_person} = Humaans.People.create(client, person_params)

  ## Telemetry

  This library emits [`:telemetry`](https://hexdocs.pm/telemetry) events for all
  API requests. See `Humaans.Telemetry` for the full list of events, measurements,
  and metadata.

  ## Pagination

  Use `Humaans.Pagination` to iterate through large result sets without loading
  everything into memory:

      # Stream all people 50 at a time
      client
      |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 50)
      |> Enum.each(fn person -> IO.puts(person.first_name) end)

      # Fetch a specific page
      {:ok, result} = Humaans.Pagination.page(client, &Humaans.People.list/2, 2, page_size: 25)
  """

  @type t :: %__MODULE__{
          access_token: String.t(),
          base_url: String.t(),
          http_client: module(),
          req_options: keyword()
        }

  @enforce_keys [:access_token, :base_url, :http_client]
  defstruct [:access_token, :base_url, :http_client, req_options: []]

  @base_url "https://app.humaans.io/api"

  @doc """
  Creates a new client with the given access token and optional parameters.

  ## Options
    * `:access_token` - The access token to use for authentication (required)
    * `:base_url` - The base URL for API requests (defaults to #{@base_url})
    * `:http_client` - HTTP client module (defaults to `Humaans.HTTPClient.Req`)
    * `:req_options` - Keyword list merged into the default `Req` client
      config. Ignored when `:http_client` is overridden.

  ## Examples
      iex> client = Humaans.new(access_token: "some-access-token")
      iex> is_map(client)
      true
  """
  @spec new(opts :: keyword()) :: map()
  def new(opts) when is_list(opts) do
    access_token = Keyword.fetch!(opts, :access_token)
    base_url = Keyword.get(opts, :base_url, @base_url)
    http_client = Keyword.get(opts, :http_client, Humaans.HTTPClient.Req)
    req_options = validate_req_options(Keyword.get(opts, :req_options, []))

    struct!(__MODULE__,
      access_token: access_token,
      base_url: base_url,
      http_client: http_client,
      req_options: req_options
    )
  end

  defp validate_req_options(nil), do: []

  defp validate_req_options(opts) when is_list(opts) do
    if Keyword.keyword?(opts) do
      opts
    else
      raise ArgumentError,
            ":req_options must be a keyword list, got: #{inspect(opts)}"
    end
  end

  defp validate_req_options(other) do
    raise ArgumentError,
          ":req_options must be a keyword list, got: #{inspect(other)}"
  end

  @doc """
  Access the Audit Events API.

  Returns the module that contains functions for working with audit event resources.
  """
  def audit_events, do: Humaans.AuditEvents

  @doc """
  Access the Bank Accounts API.

  Returns the module that contains functions for working with bank account resources.
  """
  def bank_accounts, do: Humaans.BankAccounts

  @doc """
  Access the Companies API.

  Returns the module that contains functions for working with company resources.
  """
  def companies, do: Humaans.Companies

  @doc """
  Access the Compensation Types API.

  Returns the module that contains functions for working with compensation type resources.
  """
  def compensation_types, do: Humaans.CompensationTypes

  @doc """
  Access the Compensations API.

  Returns the module that contains functions for working with compensation resources.
  """
  def compensations, do: Humaans.Compensations

  @doc """
  Access the Custom Fields API.

  Returns the module that contains functions for working with custom field resources.
  """
  def custom_fields, do: Humaans.CustomFields

  @doc """
  Access the Custom Values API.

  Returns the module that contains functions for working with custom value resources.
  """
  def custom_values, do: Humaans.CustomValues

  @doc """
  Access the Documents API.

  Returns the module that contains functions for working with document resources.
  """
  def documents, do: Humaans.Documents

  @doc """
  Access the Document Types API.

  Returns the module that contains functions for working with document type resources.
  """
  def document_types, do: Humaans.DocumentTypes

  @doc """
  Access the Document Folders API.

  Returns the module that contains functions for working with document folder resources.
  """
  def document_folders, do: Humaans.DocumentFolders

  @doc """
  Access the Emergency Contacts API.

  Returns the module that contains functions for working with emergency contact resources.
  """
  def emergency_contacts, do: Humaans.EmergencyContacts

  @doc """
  Access the Equipment API.

  Returns the module that contains functions for working with equipment resources.
  """
  def equipment, do: Humaans.Equipment

  @doc """
  Access the Equipment Types API.

  Returns the module that contains functions for working with equipment type resources.
  """
  def equipment_types, do: Humaans.EquipmentTypes

  @doc """
  Access the Equipment Names API.

  Returns the module that contains functions for working with equipment name resources.
  """
  def equipment_names, do: Humaans.EquipmentNames

  @doc """
  Access the Identity Documents API.

  Returns the module that contains functions for working with identity document resources.
  """
  def identity_documents, do: Humaans.IdentityDocuments

  @doc """
  Access the Identity Document Types API.

  Returns the module that contains functions for working with identity document type resources.
  """
  def identity_document_types, do: Humaans.IdentityDocumentTypes

  @doc """
  Access the Job Roles API.

  Returns the module that contains functions for working with job role resources.
  """
  def job_roles, do: Humaans.JobRoles

  @doc """
  Access the Locations API.

  Returns the module that contains functions for working with location resources.
  """
  def locations, do: Humaans.Locations

  @doc """
  Access the current user's profile.

  Returns `Humaans.Me`, which exposes `get/1` for retrieving the
  authenticated user's profile.
  """
  def me, do: Humaans.Me

  @doc """
  Access the OKRs API.

  Returns the module that contains functions for working with OKR resources.
  """
  def okrs, do: Humaans.OKRs

  @doc """
  Access pagination helpers.

  Returns `Humaans.Pagination`, which provides `page/4` for fetching a specific
  page and `stream/3` for lazily iterating all results.
  """
  def pagination, do: Humaans.Pagination

  @doc """
  Access the Performance Cycles API.

  Returns the module that contains functions for working with performance cycle resources.
  """
  def performance_cycles, do: Humaans.PerformanceCycles

  @doc """
  Access the Performance Templates API.

  Returns the module that contains functions for working with performance template resources.
  """
  def performance_templates, do: Humaans.PerformanceTemplates

  @doc """
  Access the Performance Reviews API.

  Returns the module that contains functions for working with performance review resources.
  """
  def performance_reviews, do: Humaans.PerformanceReviews

  @doc """
  Access the Performance Instances API.

  Returns the module that contains functions for working with performance instance resources.
  """
  def performance_instances, do: Humaans.PerformanceInstances

  @doc """
  Access the Performance Ratings API.

  Returns the module that contains functions for working with performance rating resources.
  """
  def performance_ratings, do: Humaans.PerformanceRatings

  @doc """
  Access the Performance Summaries API.

  Returns the module that contains functions for working with performance summary resources.
  """
  def performance_summaries, do: Humaans.PerformanceSummaries

  @doc """
  Access the Performance Cycle Peer Nominations API.

  Returns the module that contains functions for working with peer nomination resources.
  """
  def performance_cycle_peer_nominations, do: Humaans.PerformanceCyclePeerNominations

  @doc """
  Access the People API.

  Returns the module that contains functions for working with people resources.
  """
  def people, do: Humaans.People

  @doc """
  Access the Public Holiday Calendars API.

  Returns the module that contains functions for working with public holiday calendar resources.
  """
  def public_holiday_calendars, do: Humaans.PublicHolidayCalendars

  @doc """
  Access the Public Holiday Calendar Days API.

  Returns the module that contains functions for working with public holiday calendar day resources.
  """
  def public_holiday_calendar_days, do: Humaans.PublicHolidayCalendarDays

  @doc """
  Access the Public Holidays API.

  Returns the module that contains functions for working with public holiday resources.
  """
  def public_holidays, do: Humaans.PublicHolidays

  @doc """
  Access the query builder.

  Returns `Humaans.Query`, which provides `eq/3`, `in_/3`, `nin/3`, `gt/3`,
  `gte/3`, `lt/3`, `lte/3`, `merge/2`, and `to_params/1` for building
  filter queries.
  """
  def query, do: Humaans.Query

  @doc """
  Access the Requests API.

  Returns the module that contains functions for working with request resources.
  """
  def requests, do: Humaans.Requests

  @doc """
  Access the Request Types API.

  Returns the module that contains functions for working with request type resources.
  """
  def request_types, do: Humaans.RequestTypes

  @doc """
  Access the Request Reviews API.

  Returns the module that contains functions for working with request review resources.
  """
  def request_reviews, do: Humaans.RequestReviews

  @doc """
  Access the Request Comments API.

  Returns the module that contains functions for working with request comment resources.
  """
  def request_comments, do: Humaans.RequestComments

  @doc """
  Access the Request Activity Logs API.

  Returns the module that contains functions for working with request activity log resources.
  """
  def request_activity_logs, do: Humaans.RequestActivityLogs

  @doc """
  Access the Roles API.

  Returns the module that contains functions for working with role resources.
  """
  def roles, do: Humaans.Roles

  @doc """
  Access the Role Members API.

  Returns the module that contains functions for working with role member resources.
  """
  def role_members, do: Humaans.RoleMembers

  @doc """
  Access the Role Permissions API.

  Returns the module that contains functions for working with role permission resources.
  """
  def role_permissions, do: Humaans.RolePermissions

  @doc """
  Access the Spaces API.

  Returns the module that contains functions for working with space (team/department) resources.
  """
  def spaces, do: Humaans.Spaces

  @doc """
  Access the Tasks API.

  Returns the module that contains functions for working with task resources.
  """
  def tasks, do: Humaans.Tasks

  @doc """
  Access the Timesheet Entries API.

  Returns the module that contains functions for working with timesheet entry resources.
  """
  def timesheet_entries, do: Humaans.TimesheetEntries

  @doc """
  Access the Timesheet Submissions API.

  Returns the module that contains functions for working with timesheet submission resources.
  """
  def timesheet_submissions, do: Humaans.TimesheetSubmissions

  @doc """
  Access the Time Away API.

  Returns the module that contains functions for working with time away resources.
  """
  def time_away, do: Humaans.TimeAway

  @doc """
  Access the Time Away Allocations API.

  Returns the module that contains functions for working with time away allocation resources.
  """
  def time_away_allocations, do: Humaans.TimeAwayAllocations

  @doc """
  Access the Time Away Adjustments API.

  Returns the module that contains functions for working with time away adjustment resources.
  """
  def time_away_adjustments, do: Humaans.TimeAwayAdjustments

  @doc """
  Access the Time Away Policies API.

  Returns the module that contains functions for working with time away policy resources.
  """
  def time_away_policies, do: Humaans.TimeAwayPolicies

  @doc """
  Access the Time Away Types API.

  Returns the module that contains functions for working with time away type resources.
  """
  def time_away_types, do: Humaans.TimeAwayTypes

  @doc """
  Access the current access token's metadata.

  Returns `Humaans.TokenInfo`, which exposes `get/1` for retrieving
  metadata (scopes, personId, etc.) about the current access token.
  """
  def token_info, do: Humaans.TokenInfo

  @doc """
  Access the Webhooks API.

  Returns the module that contains functions for working with webhook resources.
  """
  def webhooks, do: Humaans.Webhooks

  @doc """
  Access the Webhook Events API.

  Returns the module that contains functions for working with webhook event resources.
  """
  def webhook_events, do: Humaans.WebhookEvents

  @doc """
  Access the Workflow Dependencies API.

  Returns the module that contains functions for working with workflow dependency resources.
  """
  def workflow_dependencies, do: Humaans.WorkflowDependencies

  @doc """
  Access the Workflow Form Responses API.

  Returns the module that contains functions for working with workflow form response resources.
  """
  def workflow_form_responses, do: Humaans.WorkflowFormResponses

  @doc """
  Access the Workflow Publications API.

  Returns the module that contains functions for working with workflow publication resources.
  """
  def workflow_publications, do: Humaans.WorkflowPublications

  @doc """
  Access the Workflow Slack Actions API.

  Returns the module that contains functions for working with workflow Slack action resources.
  """
  def workflow_slack_actions, do: Humaans.WorkflowSlackActions

  @doc """
  Access the Workflow Stats API.

  Returns the module that contains functions for working with workflow stat resources.
  """
  def workflow_stats, do: Humaans.WorkflowStats

  @doc """
  Access the Working Patterns API.

  Returns the module that contains functions for working with working pattern resources.
  """
  def working_patterns, do: Humaans.WorkingPatterns

  @doc """
  Access the Working Pattern Allocations API.

  Returns the module that contains functions for working with working pattern allocation resources.
  """
  def working_pattern_allocations, do: Humaans.WorkingPatternAllocations
end
