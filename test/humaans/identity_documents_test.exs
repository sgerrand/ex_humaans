defmodule Humaans.IdentityDocumentsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.IdentityDocuments

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of identity documents", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/identity-documents"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "id_abc",
                 "personId" => "person_abc",
                 "identityDocumentTypeId" => "type_abc",
                 "name" => "UK Passport",
                 "number" => "123456789",
                 "issuingCountry" => "GB",
                 "issueDate" => "2020-01-15",
                 "expiryDate" => "2030-01-14",
                 "fileId" => nil,
                 "file" => nil,
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.IdentityDocuments.list(client)
      assert response.id == "id_abc"
      assert response.person_id == "person_abc"
      assert response.identity_document_type_id == "type_abc"
      assert response.name == "UK Passport"
      assert response.number == "123456789"
      assert response.issuing_country == "GB"
      assert response.issue_date == ~D[2020-01-15]
      assert response.expiry_date == ~D[2030-01-14]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.IdentityDocuments.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.IdentityDocuments.list(client)
    end
  end

  describe "create/2" do
    test "creates an identity document", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "identityDocumentTypeId" => "type_abc",
        "name" => "UK Passport",
        "number" => "123456789"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/identity-documents"

        {:ok, %{status: 201, body: Map.put(params, "id", "id_new")}}
      end)

      assert {:ok, response} = Humaans.IdentityDocuments.create(client, params)
      assert response.id == "id_new"
      assert response.number == "123456789"
    end
  end

  describe "retrieve/2" do
    test "retrieves an identity document", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/identity-documents/id_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "id_abc",
             "personId" => "person_abc",
             "identityDocumentTypeId" => "type_abc",
             "name" => "UK Passport",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.IdentityDocuments.retrieve(client, "id_abc")
      assert response.name == "UK Passport"
    end
  end

  describe "update/3" do
    test "updates an identity document", %{client: client} do
      params = %{"number" => "987654321"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/identity-documents/id_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "id_abc",
             "number" => "987654321",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.IdentityDocuments.update(client, "id_abc", params)
      assert response.number == "987654321"
    end
  end

  describe "delete/2" do
    test "deletes an identity document", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/identity-documents/id_abc"

        {:ok, %{status: 200, body: %{"id" => "id_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "id_abc", deleted: true}} =
               Humaans.IdentityDocuments.delete(client, "id_abc")
    end
  end
end
