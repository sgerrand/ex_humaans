defmodule Humaans.PerformanceCyclesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PerformanceCycles

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of performance cycles", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/performance-cycles"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "pc_abc",
                 "companyId" => "company_abc",
                 "name" => "Q1 2025",
                 "status" => "open",
                 "startDate" => "2025-01-01",
                 "endDate" => "2025-03-31",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.PerformanceCycles.list(client)
      assert response.id == "pc_abc"
      assert response.name == "Q1 2025"
      assert response.status == "open"
      assert response.start_date == ~D[2025-01-01]
      assert response.end_date == ~D[2025-03-31]
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceCycles.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PerformanceCycles.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a performance cycle", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/performance-cycles/pc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "pc_abc",
             "name" => "Q1 2025",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.PerformanceCycles.retrieve(client, "pc_abc")
      assert response.name == "Q1 2025"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.PerformanceCycles, :create, 2)
    refute function_exported?(Humaans.PerformanceCycles, :update, 3)
    refute function_exported?(Humaans.PerformanceCycles, :delete, 2)
  end
end
