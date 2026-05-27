defmodule Humaans.WorkflowStatsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.WorkflowStats

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "retrieve/2" do
    test "retrieves a workflow stat", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/workflow-stats/ws_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ws_abc",
             "workflowId" => "wf_abc",
             "stats" => %{"completed" => 12, "pending" => 3},
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.WorkflowStats.retrieve(client, "ws_abc")
      assert response.stats == %{"completed" => 12, "pending" => 3}
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.WorkflowStats.retrieve(client, "missing")
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.WorkflowStats.retrieve(client, "ws_abc")
    end
  end

  test "non-retrieve actions are not exported" do
    refute function_exported?(Humaans.WorkflowStats, :list, 2)
    refute function_exported?(Humaans.WorkflowStats, :create, 2)
    refute function_exported?(Humaans.WorkflowStats, :update, 3)
    refute function_exported?(Humaans.WorkflowStats, :delete, 2)
  end
end
