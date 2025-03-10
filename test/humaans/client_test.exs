defmodule Humaans.ClientTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "get/2" do
    test "makes a get request without params", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"
        refute Keyword.has_key?(opts, :params)

        {:ok, %{status: 200, body: %{"success" => true}}}
      end)

      assert {:ok, %{status: 200, body: %{"success" => true}}} =
               Humaans.Client.get(client, "/test-path")
    end
  end

  describe "get/3" do
    test "makes a get request with params", %{client: client} do
      params = [limit: 10, skip: 5]

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"
        assert Keyword.fetch!(opts, :params) == params

        {:ok, %{status: 200, body: %{"success" => true}}}
      end)

      assert {:ok, %{status: 200, body: %{"success" => true}}} =
               Humaans.Client.get(client, "/test-path", params)
    end
  end

  describe "post/3" do
    test "makes a post request with body", %{client: client} do
      params = [name: "Test Name", email: "test@example.com"]

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"
        assert Keyword.fetch!(opts, :body) == params

        {:ok, %{status: 201, body: %{"id" => "123", "name" => "Test Name"}}}
      end)

      assert {:ok, %{status: 201, body: %{"id" => "123", "name" => "Test Name"}}} =
               Humaans.Client.post(client, "/test-path", params)
    end

    test "makes a post request with empty body", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"
        assert Keyword.fetch!(opts, :body) == []

        {:ok, %{status: 204}}
      end)

      assert {:ok, %{status: 204}} = Humaans.Client.post(client, "/test-path")
    end
  end

  describe "patch/3" do
    test "makes a patch request with body", %{client: client} do
      params = [name: "Updated Name"]

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"
        assert Keyword.fetch!(opts, :body) == params

        {:ok, %{status: 200, body: %{"id" => "123", "name" => "Updated Name"}}}
      end)

      assert {:ok, %{status: 200, body: %{"id" => "123", "name" => "Updated Name"}}} =
               Humaans.Client.patch(client, "/test-path", params)
    end

    test "makes a patch request with empty body", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"
        assert Keyword.fetch!(opts, :body) == []

        {:ok, %{status: 200, body: %{"id" => "123"}}}
      end)

      assert {:ok, %{status: 200, body: %{"id" => "123"}}} =
               Humaans.Client.patch(client, "/test-path")
    end
  end

  describe "delete/2" do
    test "makes a delete request", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/test-path"

        {:ok, %{status: 200, body: %{"id" => "123", "deleted" => true}}}
      end)

      assert {:ok, %{status: 200, body: %{"id" => "123", "deleted" => true}}} =
               Humaans.Client.delete(client, "/test-path")
    end
  end
end
