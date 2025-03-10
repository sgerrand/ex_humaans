defmodule Humaans.TimesheetSubmissionsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.TimesheetSubmissions

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of timesheet submissions", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/timesheet-submissions"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "Qh1bcl6baOIFPBgJjM0I9wNB",
                 "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
                 "startDate" => "2020-04-01",
                 "endDate" => "2020-04-30",
                 "status" => "pending",
                 "submittedAt" => "2020-04-30T17:08:29.290Z",
                 "reviewedBy" => "ob4xPcVpGGZm043C7xGMfP1U",
                 "reviewedAt" => "2020-04-30T17:08:29.290Z",
                 "changesRequested" => "Missing hours from weekend shift.",
                 "durationAsTime" => %{
                   "hours" => 127,
                   "minutes" => 30
                 },
                 "durationAsDays" => 23,
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response] = responses} = Humaans.TimesheetSubmissions.list(client)
      assert length(responses) == 1
      assert response.id == "Qh1bcl6baOIFPBgJjM0I9wNB"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.start_date == "2020-04-01"
      assert response.end_date == "2020-04-30"
      assert response.status == "pending"
      assert response.submitted_at == "2020-04-30T17:08:29.290Z"
      assert response.reviewed_by == "ob4xPcVpGGZm043C7xGMfP1U"
      assert response.reviewed_at == "2020-04-30T17:08:29.290Z"
      assert response.changes_requested == "Missing hours from weekend shift."

      assert response.duration_as_time == %{
               "hours" => 127,
               "minutes" => 30
             }

      assert response.duration_as_days == 23
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Timesheet Submission not found"}}}
      end)

      assert {:error, {404, %{"error" => "Timesheet Submission not found"}}} ==
               Humaans.TimesheetSubmissions.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.TimesheetSubmissions.list(client)
    end
  end

  describe "create/1" do
    test "creates a new timesheet submission", %{client: client} do
      params = %{personId: "IL3vneCYhIx0xrR6um2sy2nW", startDate: "2020-04-01"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/timesheet-submissions"

        {:ok,
         %{
           status: 201,
           body:
             params
             |> Map.put("id", "new_id")
             |> Map.put("created_at", "2020-01-28T08:44:42.000Z")
             |> Map.put("updated_at", "2020-01-29T14:52:21.000Z")
         }}
      end)

      assert {:ok, response} = Humaans.TimesheetSubmissions.create(client, params)
      assert response.id == "new_id"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.start_date == "2020-04-01"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "retrieve/1" do
    test "retrieves a timesheet submission", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/timesheet-submissions/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "Qh1bcl6baOIFPBgJjM0I9wNB",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "startDate" => "2020-04-01",
             "endDate" => "2020-04-30",
             "status" => "pending",
             "submittedAt" => "2020-04-30T17:08:29.290Z",
             "reviewedBy" => "ob4xPcVpGGZm043C7xGMfP1U",
             "reviewedAt" => "2020-04-30T17:08:29.290Z",
             "changesRequested" => "Missing hours from weekend shift.",
             "durationAsTime" => %{
               "hours" => 127,
               "minutes" => 30
             },
             "durationAsDays" => 23,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.TimesheetSubmissions.retrieve(client, "Ivl8mvdLO8ux7T1h1DjGtClc")

      assert response.id == "Qh1bcl6baOIFPBgJjM0I9wNB"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.start_date == "2020-04-01"
      assert response.end_date == "2020-04-30"
      assert response.status == "pending"
      assert response.submitted_at == "2020-04-30T17:08:29.290Z"
      assert response.reviewed_by == "ob4xPcVpGGZm043C7xGMfP1U"
      assert response.reviewed_at == "2020-04-30T17:08:29.290Z"
      assert response.changes_requested == "Missing hours from weekend shift."

      assert response.duration_as_time == %{
               "hours" => 127,
               "minutes" => 30
             }

      assert response.duration_as_days == 23
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a timesheet submission", %{client: client} do
      params = %{status: "pending"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/timesheet-submissions/Qh1bcl6baOIFPBgJjM0I9wNB"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "Qh1bcl6baOIFPBgJjM0I9wNB",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "startDate" => "2020-04-01",
             "endDate" => "2020-04-30",
             "status" => "pending",
             "submittedAt" => "2020-04-30T17:08:29.290Z",
             "reviewedBy" => "ob4xPcVpGGZm043C7xGMfP1U",
             "reviewedAt" => "2020-04-30T17:08:29.290Z",
             "changesRequested" => "Missing hours from weekend shift.",
             "durationAsTime" => %{
               "hours" => 127,
               "minutes" => 30
             },
             "durationAsDays" => 23,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.TimesheetSubmissions.update(client, "Qh1bcl6baOIFPBgJjM0I9wNB", params)

      assert response.id == "Qh1bcl6baOIFPBgJjM0I9wNB"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.start_date == "2020-04-01"
      assert response.end_date == "2020-04-30"
      assert response.status == "pending"
      assert response.submitted_at == "2020-04-30T17:08:29.290Z"
      assert response.reviewed_by == "ob4xPcVpGGZm043C7xGMfP1U"
      assert response.reviewed_at == "2020-04-30T17:08:29.290Z"
      assert response.changes_requested == "Missing hours from weekend shift."

      assert response.duration_as_time == %{
               "hours" => 127,
               "minutes" => 30
             }

      assert response.duration_as_days == 23
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a timesheet submission", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/timesheet-submissions/Qh1bcl6baOIFPBgJjM0I9wNB"

        {:ok, %{status: 200, body: %{"id" => "Qh1bcl6baOIFPBgJjM0I9wNB", "deleted" => true}}}
      end)

      assert {:ok, response} =
               Humaans.TimesheetSubmissions.delete(client, "Qh1bcl6baOIFPBgJjM0I9wNB")

      assert response.id == "Qh1bcl6baOIFPBgJjM0I9wNB"
      assert response.deleted == true
    end
  end
end
