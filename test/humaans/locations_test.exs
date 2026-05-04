defmodule Humaans.LocationsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Locations

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of locations", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/locations"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "loc_abc",
                 "companyId" => "company_abc",
                 "name" => "London HQ",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Locations.list(client)
      assert response.id == "loc_abc"
      assert response.name == "London HQ"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Locations.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Locations.list(client)
    end
  end

  describe "create/2" do
    test "creates a location", %{client: client} do
      params = %{"name" => "London HQ"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/locations"

        {:ok, %{status: 201, body: Map.put(params, "id", "loc_new")}}
      end)

      assert {:ok, response} = Humaans.Locations.create(client, params)
      assert response.id == "loc_new"
    end
  end

  describe "retrieve/2" do
    test "retrieves a location", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/locations/loc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "loc_abc",
             "companyId" => "company_abc",
             "name" => "London HQ",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Locations.retrieve(client, "loc_abc")
      assert response.name == "London HQ"
    end
  end

  describe "update/3" do
    test "updates a location", %{client: client} do
      params = %{"name" => "London Office"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/locations/loc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "loc_abc",
             "name" => "London Office",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Locations.update(client, "loc_abc", params)
      assert response.name == "London Office"
    end
  end

  describe "delete/2" do
    test "deletes a location", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/locations/loc_abc"

        {:ok, %{status: 200, body: %{"id" => "loc_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "loc_abc", deleted: true}} =
               Humaans.Locations.delete(client, "loc_abc")
    end
  end
end
