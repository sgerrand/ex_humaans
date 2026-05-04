defmodule Humaans.TimeAwayTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.TimeAway

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of time away records", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ta_abc",
                 "personId" => "person_abc",
                 "timeAwayTypeId" => "type_abc",
                 "startDate" => "2025-01-01",
                 "endDate" => "2025-01-05",
                 "reason" => "Vacation",
                 "notes" => "Annual holiday",
                 "status" => "approved",
                 "approvedBy" => "manager_abc",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.TimeAway.list(client)
      assert response.id == "ta_abc"
      assert response.person_id == "person_abc"
      assert response.time_away_type_id == "type_abc"
      assert response.start_date == ~D[2025-01-01]
      assert response.end_date == ~D[2025-01-05]
      assert response.reason == "Vacation"
      assert response.notes == "Annual holiday"
      assert response.status == "approved"
      assert response.approved_by == "manager_abc"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.TimeAway.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.TimeAway.list(client)
    end
  end

  describe "create/2" do
    test "creates a time away record", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "timeAwayTypeId" => "type_abc",
        "startDate" => "2025-01-01",
        "endDate" => "2025-01-05"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away"

        {:ok, %{status: 201, body: Map.put(params, "id", "ta_new")}}
      end)

      assert {:ok, response} = Humaans.TimeAway.create(client, params)
      assert response.id == "ta_new"
      assert response.start_date == ~D[2025-01-01]
      assert response.end_date == ~D[2025-01-05]
    end
  end

  describe "retrieve/2" do
    test "retrieves a time away record", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away/ta_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ta_abc",
             "personId" => "person_abc",
             "timeAwayTypeId" => "type_abc",
             "startDate" => "2025-01-01",
             "endDate" => "2025-01-05",
             "status" => "approved",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAway.retrieve(client, "ta_abc")
      assert response.id == "ta_abc"
      assert response.status == "approved"
    end
  end

  describe "update/3" do
    test "updates a time away record", %{client: client} do
      params = %{"notes" => "Updated"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away/ta_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ta_abc",
             "personId" => "person_abc",
             "timeAwayTypeId" => "type_abc",
             "startDate" => "2025-01-01",
             "endDate" => "2025-01-05",
             "notes" => "Updated",
             "status" => "approved",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAway.update(client, "ta_abc", params)
      assert response.notes == "Updated"
    end
  end

  describe "delete/2" do
    test "deletes a time away record", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away/ta_abc"

        {:ok, %{status: 200, body: %{"id" => "ta_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "ta_abc", deleted: true}} = Humaans.TimeAway.delete(client, "ta_abc")
    end
  end
end
