defmodule Humaans.TimeAwayAdjustmentsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.TimeAwayAdjustments

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of time away adjustments", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-adjustments"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "adj_abc",
                 "personId" => "person_abc",
                 "timeAwayAllocationId" => "alloc_abc",
                 "amount" => 1.5,
                 "note" => "Carry-over from last year",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.TimeAwayAdjustments.list(client)
      assert response.id == "adj_abc"
      assert response.person_id == "person_abc"
      assert response.time_away_allocation_id == "alloc_abc"
      assert response.amount == 1.5
      assert response.note == "Carry-over from last year"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.TimeAwayAdjustments.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.TimeAwayAdjustments.list(client)
    end
  end

  describe "create/2" do
    test "creates a time away adjustment", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "timeAwayAllocationId" => "alloc_abc",
        "amount" => 1.5,
        "note" => "Bonus day"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-adjustments"

        {:ok, %{status: 201, body: Map.put(params, "id", "adj_new")}}
      end)

      assert {:ok, response} = Humaans.TimeAwayAdjustments.create(client, params)
      assert response.id == "adj_new"
      assert response.amount == 1.5
    end
  end

  describe "retrieve/2" do
    test "retrieves a time away adjustment", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/time-away-adjustments/adj_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "adj_abc",
             "personId" => "person_abc",
             "timeAwayAllocationId" => "alloc_abc",
             "amount" => 1.5,
             "note" => nil,
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAwayAdjustments.retrieve(client, "adj_abc")
      assert response.id == "adj_abc"
      assert response.note == nil
    end
  end

  describe "update/3" do
    test "updates a time away adjustment", %{client: client} do
      params = %{"note" => "Updated note"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/time-away-adjustments/adj_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "adj_abc",
             "amount" => 1.5,
             "note" => "Updated note",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAwayAdjustments.update(client, "adj_abc", params)
      assert response.note == "Updated note"
    end
  end

  describe "delete/2" do
    test "deletes a time away adjustment", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/time-away-adjustments/adj_abc"

        {:ok, %{status: 200, body: %{"id" => "adj_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "adj_abc", deleted: true}} =
               Humaans.TimeAwayAdjustments.delete(client, "adj_abc")
    end
  end
end
