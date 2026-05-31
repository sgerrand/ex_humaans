defmodule Humaans.PerformanceSummariesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PerformanceSummaries

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "retrieve/2" do
    test "retrieves a performance summary", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/performance-summaries/ps_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ps_abc",
             "companyId" => "company_abc",
             "personId" => "person_abc",
             "performanceCycleId" => "pc_abc",
             "summary" => "Strong performer this cycle.",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.PerformanceSummaries.retrieve(client, "ps_abc")
      assert response.id == "ps_abc"
      assert response.company_id == "company_abc"
      assert response.person_id == "person_abc"
      assert response.performance_cycle_id == "pc_abc"
      assert response.summary == "Strong performer this cycle."
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceSummaries.retrieve(client, "missing")
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PerformanceSummaries.retrieve(client, "ps_abc")
    end
  end

  test "non-retrieve actions are not exported" do
    refute function_exported?(Humaans.PerformanceSummaries, :list, 2)
    refute function_exported?(Humaans.PerformanceSummaries, :create, 2)
    refute function_exported?(Humaans.PerformanceSummaries, :update, 3)
    refute function_exported?(Humaans.PerformanceSummaries, :delete, 2)
  end
end
