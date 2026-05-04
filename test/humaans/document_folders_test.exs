defmodule Humaans.DocumentFoldersTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.DocumentFolders

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of document folders", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/document-folders"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "folder_abc",
                 "companyId" => "company_abc",
                 "name" => "Onboarding",
                 "audience" => %{"type" => "all", "rules" => []},
                 "createdBy" => "person_def",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z",
                 "deletedAt" => nil
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.DocumentFolders.list(client)
      assert response.id == "folder_abc"
      assert response.company_id == "company_abc"
      assert response.name == "Onboarding"
      assert response.audience == %{"type" => "all", "rules" => []}
      assert response.created_by == "person_def"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.deleted_at == nil
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.DocumentFolders.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.DocumentFolders.list(client)
    end
  end

  describe "create/2" do
    test "creates a document folder", %{client: client} do
      params = %{"name" => "Onboarding"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/document-folders"

        {:ok, %{status: 201, body: Map.put(params, "id", "folder_new")}}
      end)

      assert {:ok, response} = Humaans.DocumentFolders.create(client, params)
      assert response.id == "folder_new"
      assert response.name == "Onboarding"
    end
  end

  describe "retrieve/2" do
    test "retrieves a document folder", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/document-folders/folder_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "folder_abc",
             "companyId" => "company_abc",
             "name" => "Onboarding",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.DocumentFolders.retrieve(client, "folder_abc")
      assert response.name == "Onboarding"
    end
  end

  describe "update/3" do
    test "updates a document folder", %{client: client} do
      params = %{"name" => "Onboarding Documents"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/document-folders/folder_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "folder_abc",
             "name" => "Onboarding Documents",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.DocumentFolders.update(client, "folder_abc", params)
      assert response.name == "Onboarding Documents"
    end
  end

  describe "delete/2" do
    test "deletes a document folder", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/document-folders/folder_abc"

        {:ok, %{status: 200, body: %{"id" => "folder_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "folder_abc", deleted: true}} =
               Humaans.DocumentFolders.delete(client, "folder_abc")
    end
  end
end
