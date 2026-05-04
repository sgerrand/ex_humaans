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
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
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
      assert response.nominee_id == "person_def"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceCyclePeerNominations.retrieve(client, "missing")
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

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
