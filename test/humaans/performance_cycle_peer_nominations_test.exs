defmodule Humaans.PerformanceCyclePeerNominationsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PerformanceCyclePeerNominations

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "retrieve/2" do
    test "retrieves a performance cycle peer nomination", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/performance-cycle-peer-nominations/pcpn_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "pcpn_abc",
             "companyId" => "company_abc",
             "performanceCycleId" => "pc_abc",
             "personId" => "person_abc",
             "nomineeId" => "person_def",
             "status" => "approved",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.PerformanceCyclePeerNominations.retrieve(client, "pcpn_abc")

      assert response.id == "pcpn_abc"
      assert response.company_id == "company_abc"
      assert response.performance_cycle_id == "pc_abc"
      assert response.person_id == "person_abc"
      assert response.nominee_id == "person_def"
      assert response.status == "approved"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceCyclePeerNominations.retrieve(client, "missing")
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PerformanceCyclePeerNominations.retrieve(client, "pcpn_abc")
    end
  end

  test "non-retrieve actions are not exported" do
    refute function_exported?(Humaans.PerformanceCyclePeerNominations, :list, 2)
    refute function_exported?(Humaans.PerformanceCyclePeerNominations, :create, 2)
    refute function_exported?(Humaans.PerformanceCyclePeerNominations, :update, 3)
    refute function_exported?(Humaans.PerformanceCyclePeerNominations, :delete, 2)
  end
end
