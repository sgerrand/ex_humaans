defmodule Humaans.WorkingPatternsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.WorkingPatterns

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of working patterns", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/working-patterns"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "wp_abc",
                 "companyId" => "company_abc",
                 "name" => "Mon-Fri 9-5",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.WorkingPatterns.list(client)
      assert response.id == "wp_abc"
      assert response.name == "Mon-Fri 9-5"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.WorkingPatterns.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.WorkingPatterns.list(client)
    end
  end

  describe "create/2" do
    test "creates a working pattern", %{client: client} do
      params = %{"name" => "Mon-Fri 9-5"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/working-patterns"

        {:ok, %{status: 201, body: Map.put(params, "id", "wp_new")}}
      end)

      assert {:ok, response} = Humaans.WorkingPatterns.create(client, params)
      assert response.id == "wp_new"
    end
  end

  describe "retrieve/2" do
    test "retrieves a working pattern", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/working-patterns/wp_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "wp_abc",
             "companyId" => "company_abc",
             "name" => "Mon-Fri 9-5",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.WorkingPatterns.retrieve(client, "wp_abc")
      assert response.name == "Mon-Fri 9-5"
    end
  end

  describe "update/3" do
    test "updates a working pattern", %{client: client} do
      params = %{"name" => "Mon-Thu 9-5"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/working-patterns/wp_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "wp_abc",
             "name" => "Mon-Thu 9-5",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.WorkingPatterns.update(client, "wp_abc", params)
      assert response.name == "Mon-Thu 9-5"
    end
  end

  describe "delete/2" do
    test "deletes a working pattern", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/working-patterns/wp_abc"

        {:ok, %{status: 200, body: %{"id" => "wp_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "wp_abc", deleted: true}} =
               Humaans.WorkingPatterns.delete(client, "wp_abc")
    end
  end
end
