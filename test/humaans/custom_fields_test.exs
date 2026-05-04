defmodule Humaans.CustomFieldsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.CustomFields

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of custom fields", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-fields"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "cf_abc",
                 "companyId" => "company_abc",
                 "name" => "T-shirt size",
                 "section" => "basics",
                 "resourceId" => nil,
                 "type" => "select",
                 "config" => %{"choices" => ["S", "M", "L"]},
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.CustomFields.list(client)
      assert response.id == "cf_abc"
      assert response.company_id == "company_abc"
      assert response.name == "T-shirt size"
      assert response.section == "basics"
      assert response.resource_id == nil
      assert response.type == "select"
      assert response.config == %{"choices" => ["S", "M", "L"]}
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.CustomFields.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.CustomFields.list(client)
    end
  end

  describe "create/2" do
    test "creates a custom field", %{client: client} do
      params = %{
        "name" => "T-shirt size",
        "section" => "basics",
        "type" => "select",
        "config" => %{"choices" => ["S", "M", "L"]}
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-fields"

        {:ok, %{status: 201, body: Map.put(params, "id", "cf_new")}}
      end)

      assert {:ok, response} = Humaans.CustomFields.create(client, params)
      assert response.id == "cf_new"
      assert response.type == "select"
    end
  end

  describe "retrieve/2" do
    test "retrieves a custom field", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-fields/cf_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "cf_abc",
             "companyId" => "company_abc",
             "name" => "T-shirt size",
             "section" => "basics",
             "resourceId" => "res_abc",
             "type" => "select",
             "config" => %{"choices" => ["S", "M", "L"]},
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CustomFields.retrieve(client, "cf_abc")
      assert response.id == "cf_abc"
      assert response.company_id == "company_abc"
      assert response.name == "T-shirt size"
      assert response.resource_id == "res_abc"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end
  end

  describe "update/3" do
    test "updates a custom field", %{client: client} do
      params = %{"name" => "Shirt size"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-fields/cf_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "cf_abc",
             "companyId" => "company_abc",
             "name" => "Shirt size",
             "section" => "basics",
             "resourceId" => "res_abc",
             "type" => "select",
             "config" => %{"choices" => ["S", "M", "L"]},
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CustomFields.update(client, "cf_abc", params)
      assert response.id == "cf_abc"
      assert response.company_id == "company_abc"
      assert response.name == "Shirt size"
      assert response.resource_id == "res_abc"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-02 08:44:42.000Z]
    end
  end

  describe "delete/2" do
    test "deletes a custom field", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-fields/cf_abc"

        {:ok, %{status: 200, body: %{"id" => "cf_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "cf_abc", deleted: true}} =
               Humaans.CustomFields.delete(client, "cf_abc")
    end
  end
end
