defmodule Humaans.TimesheetEntriesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.TimesheetEntries

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
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/timesheet-entries"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "0vUGk85FkSDHXfeOTnXqkk4d",
                 "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
                 "date" => "2020-04-01",
                 "startTime" => "09:00:00",
                 "endTime" => "12:30:00",
                 "duration" => %{
                   "hours" => 127,
                   "minutes" => 30
                 },
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, list} = Humaans.TimesheetEntries.list(client)
      assert is_list(list)
      assert length(list) == 1

      response = List.first(list)

      assert response.id == "0vUGk85FkSDHXfeOTnXqkk4d"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.date == "2020-04-01"
      assert response.start_time == "09:00:00"
      assert response.end_time == "12:30:00"

      assert response.duration == %{
               "hours" => 127,
               "minutes" => 30
             }

      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Timesheet Entry not found"}}}
      end)

      assert {:error, {404, %{"error" => "Timesheet Entry not found"}}} ==
               Humaans.TimesheetEntries.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.TimesheetEntries.list(client)
    end
  end

  describe "create/1" do
    test "creates a new timesheet submission", %{client: client} do
      params = %{personId: "IL3vneCYhIx0xrR6um2sy2nW", date: "2020-04-01", startTime: "09:00:00"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/timesheet-entries"

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

      assert {:ok, response} = Humaans.TimesheetEntries.create(client, params)
      assert response.id == "new_id"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.date == "2020-04-01"
      assert response.start_time == "09:00:00"
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
                 "https://app.humaans.io/api/timesheet-entries/0vUGk85FkSDHXfeOTnXqkk4d"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "0vUGk85FkSDHXfeOTnXqkk4d",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "date" => "2020-04-01",
             "startTime" => "09:00:00",
             "endTime" => "12:30:00",
             "duration" => %{
               "hours" => 127,
               "minutes" => 30
             },
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.TimesheetEntries.retrieve(client, "0vUGk85FkSDHXfeOTnXqkk4d")

      assert response.id == "0vUGk85FkSDHXfeOTnXqkk4d"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.date == "2020-04-01"
      assert response.start_time == "09:00:00"
      assert response.end_time == "12:30:00"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"

      assert response.duration == %{
               "hours" => 127,
               "minutes" => 30
             }

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
                 "https://app.humaans.io/api/timesheet-entries/0vUGk85FkSDHXfeOTnXqkk4d"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "0vUGk85FkSDHXfeOTnXqkk4d",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "date" => "2020-04-01",
             "startTime" => "09:00:00",
             "endTime" => "12:30:00",
             "duration" => %{
               "hours" => 3,
               "minutes" => 30
             },
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.TimesheetEntries.update(client, "0vUGk85FkSDHXfeOTnXqkk4d", params)

      assert response.id == "0vUGk85FkSDHXfeOTnXqkk4d"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.date == "2020-04-01"
      assert response.start_time == "09:00:00"
      assert response.end_time == "12:30:00"

      assert response.duration == %{
               "hours" => 3,
               "minutes" => 30
             }

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
                 "https://app.humaans.io/api/timesheet-entries/0vUGk85FkSDHXfeOTnXqkk4d"

        {:ok, %{status: 200, body: %{"id" => "0vUGk85FkSDHXfeOTnXqkk4d", "deleted" => true}}}
      end)

      assert {:ok, response} = Humaans.TimesheetEntries.delete(client, "0vUGk85FkSDHXfeOTnXqkk4d")
      assert response.id == "0vUGk85FkSDHXfeOTnXqkk4d"
      assert response.deleted == true
    end
  end
end
