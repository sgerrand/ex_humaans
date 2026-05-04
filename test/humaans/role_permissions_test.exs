defmodule Humaans.RolePermissionsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.RolePermissions

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of role permissions", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/role-permissions"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [%{"id" => "rp_abc", "name" => "people.read", "roleId" => "role_abc"}]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.RolePermissions.list(client)
      assert response.id == "rp_abc"
      assert response.name == "people.read"
      assert response.role_id == "role_abc"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.RolePermissions.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.RolePermissions.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a role permission", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/role-permissions/rp_abc"

        {:ok,
         %{
           status: 200,
           body: %{"id" => "rp_abc", "name" => "people.read", "roleId" => "role_abc"}
         }}
      end)

      assert {:ok, response} = Humaans.RolePermissions.retrieve(client, "rp_abc")
      assert response.name == "people.read"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.RolePermissions, :create, 2)
    refute function_exported?(Humaans.RolePermissions, :update, 3)
    refute function_exported?(Humaans.RolePermissions, :delete, 2)
  end
end
