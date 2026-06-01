defmodule HumaansTest do
  use ExUnit.Case, async: true

  doctest Humaans

  describe "new/1" do
    test "with default options" do
      client = Humaans.new(access_token: "some api key")

      assert client.access_token == "some api key"
      assert client.base_url == "https://app.humaans.io/api"
      assert client.http_client == Humaans.HTTPClient.Req
    end

    test "base URL is configurable" do
      client = Humaans.new(access_token: "some api key", base_url: "http://some-base.url/path")

      assert client.access_token == "some api key"
      assert client.base_url == "http://some-base.url/path"
      assert client.http_client == Humaans.HTTPClient.Req
    end

    test "HTTP client is configurable" do
      client = Humaans.new(access_token: "some api key", http_client: Humaans.MockHTTPClient)

      assert client.access_token == "some api key"
      assert client.base_url == "https://app.humaans.io/api"
      assert client.http_client == Humaans.MockHTTPClient
    end

    test "req_options defaults to []" do
      client = Humaans.new(access_token: "some api key")

      assert client.req_options == []
    end

    test "req_options accepts a keyword list" do
      client =
        Humaans.new(access_token: "some api key", req_options: [retry: false, max_retries: 0])

      assert client.req_options == [retry: false, max_retries: 0]
    end

    test "req_options coerces nil to []" do
      client = Humaans.new(access_token: "some api key", req_options: nil)

      assert client.req_options == []
    end

    test "req_options raises ArgumentError for non-keyword list" do
      assert_raise ArgumentError, ~r/:req_options must be a keyword list/, fn ->
        Humaans.new(access_token: "some api key", req_options: %{retry: false})
      end

      assert_raise ArgumentError, ~r/:req_options must be a keyword list/, fn ->
        Humaans.new(access_token: "some api key", req_options: "not a list")
      end

      assert_raise ArgumentError, ~r/:req_options must be a keyword list/, fn ->
        Humaans.new(access_token: "some api key", req_options: [1, 2, 3])
      end
    end
  end

  describe "struct" do
    test "all keys are required" do
      assert %Humaans{access_token: nil, base_url: nil, http_client: nil} ==
               struct!(Humaans, access_token: nil, base_url: nil, http_client: nil)
    end

    test "access_token is required" do
      assert_raise ArgumentError,
                   "the following keys must also be given when building struct Humaans: [:access_token]",
                   fn ->
                     struct!(Humaans, base_url: nil, http_client: nil)
                   end
    end

    test "base_url is required" do
      assert_raise ArgumentError,
                   "the following keys must also be given when building struct Humaans: [:base_url]",
                   fn ->
                     struct!(Humaans, access_token: nil, http_client: nil)
                   end
    end

    test "http_client is required" do
      assert_raise ArgumentError,
                   "the following keys must also be given when building struct Humaans: [:http_client]",
                   fn ->
                     struct!(Humaans, access_token: nil, base_url: nil)
                   end
    end
  end

  test "people/0 returns the People module" do
    assert Humaans.people() == Humaans.People
  end

  test "bank_accounts/0 returns the BankAccounts module" do
    assert Humaans.bank_accounts() == Humaans.BankAccounts
  end

  test "companies/0 returns the Companies module" do
    assert Humaans.companies() == Humaans.Companies
  end

  test "compensation_types/0 returns the CompensationTypes module" do
    assert Humaans.compensation_types() == Humaans.CompensationTypes
  end

  test "compensations/0 returns the Compensations module" do
    assert Humaans.compensations() == Humaans.Compensations
  end

  test "documents/0 returns the Documents module" do
    assert Humaans.documents() == Humaans.Documents
  end

  test "document_types/0 returns the DocumentTypes module" do
    assert Humaans.document_types() == Humaans.DocumentTypes
  end

  test "document_folders/0 returns the DocumentFolders module" do
    assert Humaans.document_folders() == Humaans.DocumentFolders
  end

  test "emergency_contacts/0 returns the EmergencyContacts module" do
    assert Humaans.emergency_contacts() == Humaans.EmergencyContacts
  end

  test "equipment/0 returns the Equipment module" do
    assert Humaans.equipment() == Humaans.Equipment
  end

  test "equipment_types/0 returns the EquipmentTypes module" do
    assert Humaans.equipment_types() == Humaans.EquipmentTypes
  end

  test "equipment_names/0 returns the EquipmentNames module" do
    assert Humaans.equipment_names() == Humaans.EquipmentNames
  end

  test "identity_documents/0 returns the IdentityDocuments module" do
    assert Humaans.identity_documents() == Humaans.IdentityDocuments
  end

  test "identity_document_types/0 returns the IdentityDocumentTypes module" do
    assert Humaans.identity_document_types() == Humaans.IdentityDocumentTypes
  end

  test "job_roles/0 returns the JobRoles module" do
    assert Humaans.job_roles() == Humaans.JobRoles
  end

  test "locations/0 returns the Locations module" do
    assert Humaans.locations() == Humaans.Locations
  end

  test "public_holiday_calendars/0 returns the PublicHolidayCalendars module" do
    assert Humaans.public_holiday_calendars() == Humaans.PublicHolidayCalendars
  end

  test "public_holiday_calendar_days/0 returns the PublicHolidayCalendarDays module" do
    assert Humaans.public_holiday_calendar_days() == Humaans.PublicHolidayCalendarDays
  end

  test "public_holidays/0 returns the PublicHolidays module" do
    assert Humaans.public_holidays() == Humaans.PublicHolidays
  end

  test "spaces/0 returns the Spaces module" do
    assert Humaans.spaces() == Humaans.Spaces
  end

  test "timesheet_entries/0 returns the TimesheetEntries module" do
    assert Humaans.timesheet_entries() == Humaans.TimesheetEntries
  end

  test "timesheet_submissions/0 returns the TimesheetSubmissions module" do
    assert Humaans.timesheet_submissions() == Humaans.TimesheetSubmissions
  end

  test "time_away/0 returns the TimeAway module" do
    assert Humaans.time_away() == Humaans.TimeAway
  end

  test "time_away_allocations/0 returns the TimeAwayAllocations module" do
    assert Humaans.time_away_allocations() == Humaans.TimeAwayAllocations
  end

  test "time_away_adjustments/0 returns the TimeAwayAdjustments module" do
    assert Humaans.time_away_adjustments() == Humaans.TimeAwayAdjustments
  end

  test "time_away_policies/0 returns the TimeAwayPolicies module" do
    assert Humaans.time_away_policies() == Humaans.TimeAwayPolicies
  end

  test "time_away_types/0 returns the TimeAwayTypes module" do
    assert Humaans.time_away_types() == Humaans.TimeAwayTypes
  end

  test "pagination/0 returns the Pagination module" do
    assert Humaans.pagination() == Humaans.Pagination
  end

  test "webhooks/0 returns the Webhooks module" do
    assert Humaans.webhooks() == Humaans.Webhooks
  end

  test "query/0 returns the Query module" do
    assert Humaans.query() == Humaans.Query
  end

  test "working_patterns/0 returns the WorkingPatterns module" do
    assert Humaans.working_patterns() == Humaans.WorkingPatterns
  end

  test "working_pattern_allocations/0 returns the WorkingPatternAllocations module" do
    assert Humaans.working_pattern_allocations() == Humaans.WorkingPatternAllocations
  end

  test "audit_events/0 returns the AuditEvents module" do
    assert Humaans.audit_events() == Humaans.AuditEvents
  end

  test "roles/0 returns the Roles module" do
    assert Humaans.roles() == Humaans.Roles
  end

  test "role_members/0 returns the RoleMembers module" do
    assert Humaans.role_members() == Humaans.RoleMembers
  end

  test "role_permissions/0 returns the RolePermissions module" do
    assert Humaans.role_permissions() == Humaans.RolePermissions
  end

  test "tasks/0 returns the Tasks module" do
    assert Humaans.tasks() == Humaans.Tasks
  end

  test "okrs/0 returns the OKRs module" do
    assert Humaans.okrs() == Humaans.OKRs
  end

  test "webhook_events/0 returns the WebhookEvents module" do
    assert Humaans.webhook_events() == Humaans.WebhookEvents
  end

  test "performance_cycles/0 returns the PerformanceCycles module" do
    assert Humaans.performance_cycles() == Humaans.PerformanceCycles
  end

  test "performance_templates/0 returns the PerformanceTemplates module" do
    assert Humaans.performance_templates() == Humaans.PerformanceTemplates
  end

  test "performance_reviews/0 returns the PerformanceReviews module" do
    assert Humaans.performance_reviews() == Humaans.PerformanceReviews
  end

  test "performance_instances/0 returns the PerformanceInstances module" do
    assert Humaans.performance_instances() == Humaans.PerformanceInstances
  end

  test "performance_ratings/0 returns the PerformanceRatings module" do
    assert Humaans.performance_ratings() == Humaans.PerformanceRatings
  end

  test "performance_summaries/0 returns the PerformanceSummaries module" do
    assert Humaans.performance_summaries() == Humaans.PerformanceSummaries
  end

  test "performance_cycle_peer_nominations/0 returns the PerformanceCyclePeerNominations module" do
    assert Humaans.performance_cycle_peer_nominations() ==
             Humaans.PerformanceCyclePeerNominations
  end

  test "requests/0 returns the Requests module" do
    assert Humaans.requests() == Humaans.Requests
  end

  test "request_types/0 returns the RequestTypes module" do
    assert Humaans.request_types() == Humaans.RequestTypes
  end

  test "request_reviews/0 returns the RequestReviews module" do
    assert Humaans.request_reviews() == Humaans.RequestReviews
  end

  test "request_comments/0 returns the RequestComments module" do
    assert Humaans.request_comments() == Humaans.RequestComments
  end

  test "request_activity_logs/0 returns the RequestActivityLogs module" do
    assert Humaans.request_activity_logs() == Humaans.RequestActivityLogs
  end

  test "workflow_dependencies/0 returns the WorkflowDependencies module" do
    assert Humaans.workflow_dependencies() == Humaans.WorkflowDependencies
  end

  test "workflow_form_responses/0 returns the WorkflowFormResponses module" do
    assert Humaans.workflow_form_responses() == Humaans.WorkflowFormResponses
  end

  test "workflow_publications/0 returns the WorkflowPublications module" do
    assert Humaans.workflow_publications() == Humaans.WorkflowPublications
  end

  test "workflow_slack_actions/0 returns the WorkflowSlackActions module" do
    assert Humaans.workflow_slack_actions() == Humaans.WorkflowSlackActions
  end

  test "workflow_stats/0 returns the WorkflowStats module" do
    assert Humaans.workflow_stats() == Humaans.WorkflowStats
  end
end
