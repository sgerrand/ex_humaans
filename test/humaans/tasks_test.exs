defmodule Humaans.TasksTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Tasks

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of tasks", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/tasks"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "task_abc",
                 "companyId" => "company_abc",
                 "personId" => "person_abc",
                 "title" => "Sign offer letter",
                 "description" => "Onboarding task",
                 "status" => "open",
                 "priority" => "high",
                 "dueDate" => "2025-02-01",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Tasks.list(client)
      assert response.id == "task_abc"
      assert response.title == "Sign offer letter"
      assert response.status == "open"
      assert response.priority == "high"
      assert response.due_date == ~D[2025-02-01]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Tasks.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Tasks.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a task", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/tasks/task_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "task_abc",
             "title" => "Sign offer letter",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Tasks.retrieve(client, "task_abc")
      assert response.title == "Sign offer letter"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.Tasks, :create, 2)
    refute function_exported?(Humaans.Tasks, :update, 3)
    refute function_exported?(Humaans.Tasks, :delete, 2)
  end
end
