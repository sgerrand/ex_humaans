defmodule Humaans.EquipmentTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Equipment

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of equipment", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/equipment"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "eq_abc",
                 "personId" => "person_abc",
                 "equipmentTypeId" => "type_abc",
                 "equipmentNameId" => "name_abc",
                 "serialNumber" => "ABC-123",
                 "assignedDate" => "2025-01-01",
                 "returnedDate" => nil,
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Equipment.list(client)
      assert response.id == "eq_abc"
      assert response.person_id == "person_abc"
      assert response.equipment_type_id == "type_abc"
      assert response.equipment_name_id == "name_abc"
      assert response.serial_number == "ABC-123"
      assert response.assigned_date == ~D[2025-01-01]
      assert response.returned_date == nil
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Equipment.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Equipment.list(client)
    end
  end

  describe "create/2" do
    test "creates an equipment record", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "equipmentTypeId" => "type_abc",
        "equipmentNameId" => "name_abc",
        "serialNumber" => "ABC-123"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/equipment"

        {:ok, %{status: 201, body: Map.put(params, "id", "eq_new")}}
      end)

      assert {:ok, response} = Humaans.Equipment.create(client, params)
      assert response.id == "eq_new"
    end
  end

  describe "retrieve/2" do
    test "retrieves an equipment record", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/equipment/eq_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "eq_abc",
             "serialNumber" => "ABC-123",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Equipment.retrieve(client, "eq_abc")
      assert response.serial_number == "ABC-123"
    end
  end

  describe "update/3" do
    test "updates an equipment record", %{client: client} do
      params = %{"returnedDate" => "2025-12-31"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/equipment/eq_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "eq_abc",
             "returnedDate" => "2025-12-31",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Equipment.update(client, "eq_abc", params)
      assert response.returned_date == ~D[2025-12-31]
    end
  end

  describe "delete/2" do
    test "deletes an equipment record", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/equipment/eq_abc"

        {:ok, %{status: 200, body: %{"id" => "eq_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "eq_abc", deleted: true}} = Humaans.Equipment.delete(client, "eq_abc")
    end
  end
end
