defmodule Humaans.SpacesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Spaces

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of spaces", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/spaces"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "space_abc",
                 "companyId" => "company_abc",
                 "name" => "Engineering",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Spaces.list(client)
      assert response.id == "space_abc"
      assert response.name == "Engineering"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Spaces.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Spaces.list(client)
    end
  end

  describe "create/2" do
    test "creates a space", %{client: client} do
      params = %{"name" => "Engineering"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/spaces"

        {:ok, %{status: 201, body: Map.put(params, "id", "space_new")}}
      end)

      assert {:ok, response} = Humaans.Spaces.create(client, params)
      assert response.id == "space_new"
    end
  end

  describe "retrieve/2" do
    test "retrieves a space", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/spaces/space_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "space_abc",
             "companyId" => "company_abc",
             "name" => "Engineering",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Spaces.retrieve(client, "space_abc")
      assert response.name == "Engineering"
    end
  end

  describe "update/3" do
    test "updates a space", %{client: client} do
      params = %{"name" => "Platform Engineering"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/spaces/space_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "space_abc",
             "name" => "Platform Engineering",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Spaces.update(client, "space_abc", params)
      assert response.name == "Platform Engineering"
    end
  end

  describe "delete/2" do
    test "deletes a space", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/spaces/space_abc"

        {:ok, %{status: 200, body: %{"id" => "space_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "space_abc", deleted: true}} =
               Humaans.Spaces.delete(client, "space_abc")
    end
  end
end
