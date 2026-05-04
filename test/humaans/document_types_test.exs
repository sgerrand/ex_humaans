defmodule Humaans.DocumentTypesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.DocumentTypes

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of document types", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/document-types"

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
                 "name" => "Passport",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.DocumentTypes.list(client)
      assert response.id == "type_abc"
      assert response.company_id == "company_abc"
      assert response.name == "Passport"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.DocumentTypes.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.DocumentTypes.list(client)
    end
  end

  describe "create/2" do
    test "creates a document type", %{client: client} do
      params = %{"name" => "Passport"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/document-types"

        {:ok, %{status: 201, body: Map.put(params, "id", "type_new")}}
      end)

      assert {:ok, response} = Humaans.DocumentTypes.create(client, params)
      assert response.id == "type_new"
      assert response.name == "Passport"
    end
  end

  describe "retrieve/2" do
    test "retrieves a document type", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/document-types/type_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "type_abc",
             "companyId" => "company_abc",
             "name" => "Passport",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.DocumentTypes.retrieve(client, "type_abc")
      assert response.name == "Passport"
    end
  end

  describe "update/3" do
    test "updates a document type", %{client: client} do
      params = %{"name" => "Identity Document"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/document-types/type_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "type_abc",
             "companyId" => "company_abc",
             "name" => "Identity Document",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.DocumentTypes.update(client, "type_abc", params)
      assert response.name == "Identity Document"
    end
  end

  test "delete/2 is not exported" do
    refute function_exported?(Humaans.DocumentTypes, :delete, 2)
  end
end
