defmodule Humaans.WorkingPatternAllocationsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.WorkingPatternAllocations

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of working pattern allocations", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/working-pattern-allocations"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "wpa_abc",
                 "personId" => "person_abc",
                 "workingPatternId" => "wp_abc",
                 "startDate" => "2025-01-01",
                 "endDate" => "2025-12-31",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.WorkingPatternAllocations.list(client)
      assert response.id == "wpa_abc"
      assert response.person_id == "person_abc"
      assert response.working_pattern_id == "wp_abc"
      assert response.start_date == ~D[2025-01-01]
      assert response.end_date == ~D[2025-12-31]
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.WorkingPatternAllocations.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.WorkingPatternAllocations.list(client)
    end
  end

  describe "create/2" do
    test "creates a working pattern allocation", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "workingPatternId" => "wp_abc",
        "startDate" => "2025-01-01"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/working-pattern-allocations"

        {:ok, %{status: 201, body: Map.put(params, "id", "wpa_new")}}
      end)

      assert {:ok, response} = Humaans.WorkingPatternAllocations.create(client, params)
      assert response.id == "wpa_new"
      assert response.start_date == ~D[2025-01-01]
    end
  end

  describe "retrieve/2" do
    test "retrieves a working pattern allocation", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/working-pattern-allocations/wpa_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "wpa_abc",
             "personId" => "person_abc",
             "workingPatternId" => "wp_abc",
             "startDate" => "2025-01-01",
             "endDate" => nil,
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.WorkingPatternAllocations.retrieve(client, "wpa_abc")
      assert response.end_date == nil
    end
  end

  describe "update/3" do
    test "updates a working pattern allocation", %{client: client} do
      params = %{"endDate" => "2025-12-31"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/working-pattern-allocations/wpa_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "wpa_abc",
             "personId" => "person_abc",
             "workingPatternId" => "wp_abc",
             "startDate" => "2025-01-01",
             "endDate" => "2025-12-31",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.WorkingPatternAllocations.update(client, "wpa_abc", params)

      assert response.end_date == ~D[2025-12-31]
    end
  end

  describe "delete/2" do
    test "deletes a working pattern allocation", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/working-pattern-allocations/wpa_abc"

        {:ok, %{status: 200, body: %{"id" => "wpa_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "wpa_abc", deleted: true}} =
               Humaans.WorkingPatternAllocations.delete(client, "wpa_abc")
    end
  end
end
