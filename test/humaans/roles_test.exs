defmodule Humaans.RolesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Roles

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of roles", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/roles"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [%{"id" => "role_abc", "name" => "Admin"}]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Roles.list(client)
      assert response.id == "role_abc"
      assert response.name == "Admin"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Roles.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Roles.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a role", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/roles/role_abc"

        {:ok, %{status: 200, body: %{"id" => "role_abc", "name" => "Admin"}}}
      end)

      assert {:ok, response} = Humaans.Roles.retrieve(client, "role_abc")
      assert response.name == "Admin"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.Roles, :create, 2)
    refute function_exported?(Humaans.Roles, :update, 3)
    refute function_exported?(Humaans.Roles, :delete, 2)
  end
end
