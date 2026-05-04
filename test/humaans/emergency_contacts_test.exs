defmodule Humaans.EmergencyContactsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.EmergencyContacts

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of emergency contacts", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/emergency-contacts"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ec_abc",
                 "personId" => "person_abc",
                 "name" => "Jane Doe",
                 "relationship" => "Sibling",
                 "phoneNumber" => "+44 7700 900000",
                 "email" => "jane@example.com",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.EmergencyContacts.list(client)
      assert response.id == "ec_abc"
      assert response.person_id == "person_abc"
      assert response.name == "Jane Doe"
      assert response.relationship == "Sibling"
      assert response.phone_number == "+44 7700 900000"
      assert response.email == "jane@example.com"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.EmergencyContacts.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.EmergencyContacts.list(client)
    end
  end

  describe "create/2" do
    test "creates an emergency contact", %{client: client} do
      params = %{"personId" => "person_abc", "name" => "Jane Doe"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/emergency-contacts"

        {:ok, %{status: 201, body: Map.put(params, "id", "ec_new")}}
      end)

      assert {:ok, response} = Humaans.EmergencyContacts.create(client, params)
      assert response.id == "ec_new"
    end
  end

  describe "retrieve/2" do
    test "retrieves an emergency contact", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/emergency-contacts/ec_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ec_abc",
             "personId" => "person_abc",
             "name" => "Jane Doe",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EmergencyContacts.retrieve(client, "ec_abc")
      assert response.name == "Jane Doe"
    end
  end

  describe "update/3" do
    test "updates an emergency contact", %{client: client} do
      params = %{"phoneNumber" => "+44 7700 900001"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/emergency-contacts/ec_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ec_abc",
             "phoneNumber" => "+44 7700 900001",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EmergencyContacts.update(client, "ec_abc", params)
      assert response.phone_number == "+44 7700 900001"
    end
  end

  describe "delete/2" do
    test "deletes an emergency contact", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/emergency-contacts/ec_abc"

        {:ok, %{status: 200, body: %{"id" => "ec_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "ec_abc", deleted: true}} =
               Humaans.EmergencyContacts.delete(client, "ec_abc")
    end
  end
end
