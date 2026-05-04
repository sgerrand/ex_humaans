defmodule Humaans.PerformanceInstancesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PerformanceInstances

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of performance instances", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/performance-instances"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "pi_abc",
                 "companyId" => "company_abc",
                 "performanceCycleId" => "pc_abc",
                 "personId" => "person_abc",
                 "status" => "open",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.PerformanceInstances.list(client)
      assert response.id == "pi_abc"
      assert response.performance_cycle_id == "pc_abc"
      assert response.person_id == "person_abc"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceInstances.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PerformanceInstances.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a performance instance", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/performance-instances/pi_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "pi_abc",
             "performanceCycleId" => "pc_abc",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.PerformanceInstances.retrieve(client, "pi_abc")
      assert response.performance_cycle_id == "pc_abc"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.PerformanceInstances, :create, 2)
    refute function_exported?(Humaans.PerformanceInstances, :update, 3)
    refute function_exported?(Humaans.PerformanceInstances, :delete, 2)
  end
end
