defmodule Humaans.TimesheetEntriesTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.TimesheetEntries

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of timesheet submissions" do
      expect(Humaans.MockClient, :get, fn path, _params ->
        assert path == "/timesheet-entries"

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

      assert {:ok, list} = Humaans.TimesheetEntries.list()
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

    test "returns error when resource is not found" do
      expect(Humaans.MockClient, :get, fn _path, _params ->
        {:ok, %{status: 404, body: %{"error" => "Timesheet Entry not found"}}}
      end)

      assert {:error, {404, %{"error" => "Timesheet Entry not found"}}} ==
               Humaans.TimesheetEntries.list()
    end

    test "returns error when request fails" do
      expect(Humaans.MockClient, :get, fn _path, _params ->
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.TimesheetEntries.list()
    end
  end

  describe "create/1" do
    test "creates a new timesheet submission" do
      params = %{personId: "IL3vneCYhIx0xrR6um2sy2nW", date: "2020-04-01", startTime: "09:00:00"}

      expect(Humaans.MockClient, :post, fn path, ^params ->
        assert path == "/timesheet-entries"

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

      assert {:ok, response} = Humaans.TimesheetEntries.create(params)
      assert response.id == "new_id"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.date == "2020-04-01"
      assert response.start_time == "09:00:00"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "retrieve/1" do
    test "retrieves a timesheet submission" do
      expect(Humaans.MockClient, :get, fn path ->
        assert path == "/timesheet-entries/0vUGk85FkSDHXfeOTnXqkk4d"

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

      assert {:ok, response} = Humaans.TimesheetEntries.retrieve("0vUGk85FkSDHXfeOTnXqkk4d")
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
    test "updates a timesheet submission" do
      params = %{status: "pending"}

      expect(Humaans.MockClient, :patch, fn path, ^params ->
        assert path == "/timesheet-entries/0vUGk85FkSDHXfeOTnXqkk4d"

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
               Humaans.TimesheetEntries.update("0vUGk85FkSDHXfeOTnXqkk4d", params)

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
    test "deletes a timesheet submission" do
      expect(Humaans.MockClient, :delete, fn path ->
        assert path == "/timesheet-entries/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok, %{status: 200, body: %{"id" => "Ivl8mvdLO8ux7T1h1DjGtClc", "deleted" => true}}}
      end)

      assert {:ok, response} = Humaans.TimesheetEntries.delete("Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.deleted == true
    end
  end
end
