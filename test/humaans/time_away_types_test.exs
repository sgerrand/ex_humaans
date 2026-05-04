defmodule Humaans.TimeAwayTypesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.TimeAwayTypes

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of time away types", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-types"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "type_abc",
                 "companyId" => "company_abc",
                 "name" => "Holiday",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.TimeAwayTypes.list(client)
      assert response.id == "type_abc"
      assert response.company_id == "company_abc"
      assert response.name == "Holiday"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.TimeAwayTypes.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.TimeAwayTypes.list(client)
    end
  end

  describe "create/2" do
    test "creates a time away type", %{client: client} do
      params = %{"name" => "Holiday"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-types"

        {:ok, %{status: 201, body: Map.put(params, "id", "type_new")}}
      end)

      assert {:ok, response} = Humaans.TimeAwayTypes.create(client, params)
      assert response.id == "type_new"
      assert response.name == "Holiday"
    end
  end

  describe "retrieve/2" do
    test "retrieves a time away type", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-types/type_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "type_abc",
             "companyId" => "company_abc",
             "name" => "Holiday",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAwayTypes.retrieve(client, "type_abc")
      assert response.name == "Holiday"
    end
  end

  describe "update/3" do
    test "updates a time away type", %{client: client} do
      params = %{"name" => "Annual Leave"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-types/type_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "type_abc",
             "companyId" => "company_abc",
             "name" => "Annual Leave",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.TimeAwayTypes.update(client, "type_abc", params)
      assert response.name == "Annual Leave"
    end
  end

  describe "delete/2" do
    test "deletes a time away type", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/time-away-types/type_abc"

        {:ok, %{status: 200, body: %{"id" => "type_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "type_abc", deleted: true}} =
               Humaans.TimeAwayTypes.delete(client, "type_abc")
    end
  end
end
