defmodule Humaans.RequestActivityLogsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.RequestActivityLogs

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of request activity logs", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/request-activity-logs"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ral_abc",
                 "requestId" => "req_abc",
                 "personId" => "person_def",
                 "action" => "submitted",
                 "data" => %{},
                 "createdAt" => "2025-01-01T08:44:42.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.RequestActivityLogs.list(client)
      assert response.request_id == "req_abc"
      assert response.action == "submitted"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.RequestActivityLogs.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.RequestActivityLogs.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a request activity log", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/request-activity-logs/ral_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ral_abc",
             "action" => "submitted",
             "createdAt" => "2025-01-01T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.RequestActivityLogs.retrieve(client, "ral_abc")
      assert response.action == "submitted"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.RequestActivityLogs, :create, 2)
    refute function_exported?(Humaans.RequestActivityLogs, :update, 3)
    refute function_exported?(Humaans.RequestActivityLogs, :delete, 2)
  end
end
