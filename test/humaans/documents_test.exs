defmodule Humaans.DocumentsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Documents

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of documents", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/documents"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "doc_abc",
                 "companyId" => "company_abc",
                 "personId" => "person_abc",
                 "name" => "Passport",
                 "documentTypeId" => "type_abc",
                 "folderId" => "folder_abc",
                 "link" => nil,
                 "fileId" => "file_abc",
                 "file" => %{
                   "id" => "file_abc",
                   "url" => "https://files.example.com/passport.pdf",
                   "filename" => "passport.pdf"
                 },
                 "source" => nil,
                 "sourceId" => nil,
                 "issueDate" => "2024-06-01",
                 "createdBy" => "person_def",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Documents.list(client)
      assert response.id == "doc_abc"
      assert response.company_id == "company_abc"
      assert response.person_id == "person_abc"
      assert response.name == "Passport"
      assert response.document_type_id == "type_abc"
      assert response.folder_id == "folder_abc"
      assert response.link == nil
      assert response.file_id == "file_abc"
      assert response.file["filename"] == "passport.pdf"
      assert response.issue_date == ~D[2024-06-01]
      assert response.created_by == "person_def"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Documents.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Documents.list(client)
    end
  end

  describe "create/2" do
    test "creates a document", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "documentTypeId" => "type_abc",
        "name" => "Passport",
        "link" => "https://example.com/p.pdf"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/documents"

        {:ok, %{status: 201, body: Map.put(params, "id", "doc_new")}}
      end)

      assert {:ok, response} = Humaans.Documents.create(client, params)
      assert response.id == "doc_new"
      assert response.name == "Passport"
    end
  end

  describe "retrieve/2" do
    test "retrieves a document", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/documents/doc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "doc_abc",
             "name" => "Passport",
             "documentTypeId" => "type_abc",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Documents.retrieve(client, "doc_abc")
      assert response.name == "Passport"
    end
  end

  describe "update/3" do
    test "updates a document", %{client: client} do
      params = %{"name" => "Passport (renewed)"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/documents/doc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "doc_abc",
             "name" => "Passport (renewed)",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Documents.update(client, "doc_abc", params)
      assert response.name == "Passport (renewed)"
    end
  end

  describe "delete/2" do
    test "deletes a document", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/documents/doc_abc"

        {:ok, %{status: 200, body: %{"id" => "doc_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "doc_abc", deleted: true}} = Humaans.Documents.delete(client, "doc_abc")
    end
  end
end
