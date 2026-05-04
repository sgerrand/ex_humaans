defmodule Humaans.RoleMembersTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.RoleMembers

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of role members", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/role-members"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [%{"id" => "rm_abc", "personId" => "person_abc", "roleId" => "role_abc"}]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.RoleMembers.list(client)
      assert response.id == "rm_abc"
      assert response.person_id == "person_abc"
      assert response.role_id == "role_abc"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.RoleMembers.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.RoleMembers.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a role member", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/role-members/rm_abc"

        {:ok,
         %{
           status: 200,
           body: %{"id" => "rm_abc", "personId" => "person_abc", "roleId" => "role_abc"}
         }}
      end)

      assert {:ok, response} = Humaans.RoleMembers.retrieve(client, "rm_abc")
      assert response.role_id == "role_abc"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.RoleMembers, :create, 2)
    refute function_exported?(Humaans.RoleMembers, :update, 3)
    refute function_exported?(Humaans.RoleMembers, :delete, 2)
  end
end
