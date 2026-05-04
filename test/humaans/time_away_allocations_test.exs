defmodule Humaans.TimeAwayAllocationsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.TimeAwayAllocations

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of time away allocations", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-allocations"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "alloc_abc",
                 "personId" => "person_abc",
                 "timeAwayTypeId" => "type_abc",
                 "timeAwayPolicyId" => "policy_abc",
                 "amount" => 25,
                 "unit" => "days",
                 "startDate" => "2025-01-01",
                 "endDate" => "2025-12-31",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.TimeAwayAllocations.list(client)
      assert response.id == "alloc_abc"
      assert response.person_id == "person_abc"
      assert response.time_away_type_id == "type_abc"
      assert response.time_away_policy_id == "policy_abc"
      assert response.amount == 25
      assert response.unit == "days"
      assert response.start_date == ~D[2025-01-01]
      assert response.end_date == ~D[2025-12-31]
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.TimeAwayAllocations.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.TimeAwayAllocations.list(client)
    end
  end

  describe "create/2" do
    test "creates a time away allocation", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "timeAwayTypeId" => "type_abc",
        "timeAwayPolicyId" => "policy_abc",
        "amount" => 25,
        "unit" => "days",
        "startDate" => "2025-01-01"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-allocations"

        {:ok, %{status: 201, body: Map.put(params, "id", "alloc_new")}}
      end)

      assert {:ok, response} = Humaans.TimeAwayAllocations.create(client, params)
      assert response.id == "alloc_new"
      assert response.amount == 25
      assert response.unit == "days"
    end
  end

  describe "retrieve/2" do
    test "retrieves a time away allocation", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/time-away-allocations/alloc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "alloc_abc",
             "personId" => "person_abc",
             "timeAwayTypeId" => "type_abc",
             "timeAwayPolicyId" => "policy_abc",
             "amount" => 25,
             "unit" => "days",
             "startDate" => "2025-01-01",
             "endDate" => nil,
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAwayAllocations.retrieve(client, "alloc_abc")
      assert response.id == "alloc_abc"
      assert response.end_date == nil
    end
  end

  describe "update/3" do
    test "updates a time away allocation", %{client: client} do
      params = %{"amount" => 30}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/time-away-allocations/alloc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "alloc_abc",
             "amount" => 30,
             "unit" => "days",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAwayAllocations.update(client, "alloc_abc", params)
      assert response.amount == 30
    end
  end

  describe "delete/2" do
    test "deletes a time away allocation", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/time-away-allocations/alloc_abc"

        {:ok, %{status: 200, body: %{"id" => "alloc_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "alloc_abc", deleted: true}} =
               Humaans.TimeAwayAllocations.delete(client, "alloc_abc")
    end
  end
end
