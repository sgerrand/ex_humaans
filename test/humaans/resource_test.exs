defmodule Humaans.ResourceTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  # Minimal struct used by the test resources below.
  defmodule TestItem do
    defstruct [:id, :name]
    use ExConstructor, :build
    def new(data), do: build(data)
    @type t :: %__MODULE__{id: binary | nil, name: binary | nil}
  end

  # Full CRUD resource — exercises the default :actions list.
  defmodule TestResource do
    use Humaans.Resource,
      path: "/test-items",
      struct: Humaans.ResourceTest.TestItem
  end

  # Restricted resource — only :list and :update generated.
  defmodule RestrictedResource do
    use Humaans.Resource,
      path: "/restricted",
      struct: Humaans.ResourceTest.TestItem,
      actions: [:list, :update]
  end

  # Resource that overrides one generated function.
  defmodule OverridingResource do
    use Humaans.Resource,
      path: "/overriding",
      struct: Humaans.ResourceTest.TestItem

    def list(_client, _params), do: {:ok, :overridden}
  end

  # Resource using binary string doc_params — exercises extract_string(s when is_binary)
  # and the if cp/up doc string branches.
  defmodule DocParamsResource do
    use Humaans.Resource,
      path: "/doc-params-items",
      struct: Humaans.ResourceTest.TestItem,
      doc_params: [
        create: "%{name: \"example\"}",
        update: "%{name: \"updated\"}"
      ]
  end

  # Resource using ~s sigil doc_params — exercises extract_string({:sigil_s, ...}).
  defmodule SigilDocParamsResource do
    use Humaans.Resource,
      path: "/sigil-doc-params-items",
      struct: Humaans.ResourceTest.TestItem,
      doc_params: [
        create: ~s(%{name: "example"}),
        update: ~s(%{name: "updated"})
      ]
  end

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "test-token", http_client: Humaans.MockHTTPClient)
    {:ok, client: client}
  end

  describe "list/2" do
    test "sends GET to the resource path", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :get
        assert String.ends_with?(Keyword.fetch!(opts, :url), "/test-items")
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      assert {:ok, []} = TestResource.list(client)
    end

    test "returns deserialized structs", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 200, body: %{"data" => [%{"id" => "abc", "name" => "Test"}]}}}
      end)

      assert {:ok, [%TestItem{id: "abc", name: "Test"}]} = TestResource.list(client)
    end

    test "forwards params to the request", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :params) == %{name: "Test"}
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      assert {:ok, []} = TestResource.list(client, %{name: "Test"})
    end

    test "returns an error on non-2xx response", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 401, body: %{"error" => "unauthorized"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 401}} = TestResource.list(client)
    end

    test "returns an error on network failure", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:error, :econnrefused}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: :econnrefused}} =
               TestResource.list(client)
    end
  end

  describe "create/2" do
    test "sends POST to the resource path", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :post
        assert String.ends_with?(Keyword.fetch!(opts, :url), "/test-items")
        {:ok, %{status: 201, body: %{"id" => "new", "name" => "New"}}}
      end)

      assert {:ok, %TestItem{id: "new"}} = TestResource.create(client, %{name: "New"})
    end

    test "returns an error on non-2xx response", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 422, body: %{"error" => "invalid"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 422}} =
               TestResource.create(client, %{})
    end
  end

  describe "retrieve/2" do
    test "sends GET to the resource path with ID", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :get
        assert String.ends_with?(Keyword.fetch!(opts, :url), "/test-items/abc123")
        {:ok, %{status: 200, body: %{"id" => "abc123", "name" => "Test"}}}
      end)

      assert {:ok, %TestItem{id: "abc123"}} = TestResource.retrieve(client, "abc123")
    end

    test "returns an error on non-2xx response", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 404, body: %{"error" => "not_found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               TestResource.retrieve(client, "missing")
    end
  end

  describe "update/3" do
    test "sends PATCH to the resource path with ID", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :patch
        assert String.ends_with?(Keyword.fetch!(opts, :url), "/test-items/abc123")
        {:ok, %{status: 200, body: %{"id" => "abc123", "name" => "Updated"}}}
      end)

      assert {:ok, %TestItem{id: "abc123", name: "Updated"}} =
               TestResource.update(client, "abc123", %{name: "Updated"})
    end

    test "returns an error on non-2xx response", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 404, body: %{"error" => "not_found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               TestResource.update(client, "missing", %{})
    end
  end

  describe "delete/2" do
    test "sends DELETE to the resource path with ID", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :delete
        assert String.ends_with?(Keyword.fetch!(opts, :url), "/test-items/abc123")
        {:ok, %{status: 200, body: %{"id" => "abc123", "deleted" => true}}}
      end)

      assert {:ok, %{id: "abc123", deleted: true}} = TestResource.delete(client, "abc123")
    end

    test "returns an error on non-2xx response", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 404, body: %{"error" => "not_found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               TestResource.delete(client, "missing")
    end
  end

  describe ":actions option" do
    test "generates only the specified actions" do
      assert function_exported?(RestrictedResource, :list, 2)
      assert function_exported?(RestrictedResource, :update, 3)
      refute function_exported?(RestrictedResource, :create, 2)
      refute function_exported?(RestrictedResource, :retrieve, 2)
      refute function_exported?(RestrictedResource, :delete, 2)
    end
  end

  describe "defoverridable" do
    test "generated functions can be overridden", %{client: client} do
      assert {:ok, :overridden} = OverridingResource.list(client, %{})
    end
  end

  describe "doc_params option" do
    test "generates CRUD functions with binary string doc_params" do
      assert function_exported?(DocParamsResource, :list, 2)
      assert function_exported?(DocParamsResource, :create, 2)
      assert function_exported?(DocParamsResource, :update, 3)
    end

    test "generates CRUD functions with sigil doc_params" do
      assert function_exported?(SigilDocParamsResource, :list, 2)
      assert function_exported?(SigilDocParamsResource, :create, 2)
      assert function_exported?(SigilDocParamsResource, :update, 3)
    end
  end
end
