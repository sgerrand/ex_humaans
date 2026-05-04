defmodule Humaans.CustomValuesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.CustomValues

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of custom values", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-values"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 2,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "cv_abc",
                 "personId" => "person_abc",
                 "customFieldId" => "cf_abc",
                 "resourceId" => nil,
                 "value" => "M",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               },
               %{
                 "id" => "cv_def",
                 "personId" => "person_def",
                 "customFieldId" => "cf_multi",
                 "resourceId" => nil,
                 "value" => ["foo", "bar"],
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, responses} = Humaans.CustomValues.list(client)
      assert length(responses) == 2

      multi = Enum.find(responses, &(&1.id == "cv_def"))
      single = Enum.find(responses, &(&1.id == "cv_abc"))

      assert single.person_id == "person_abc"
      assert single.custom_field_id == "cf_abc"
      assert single.value == "M"
      assert multi.value == ["foo", "bar"]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.CustomValues.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.CustomValues.list(client)
    end
  end

  describe "create/2" do
    test "creates a custom value", %{client: client} do
      params = %{
        "personId" => "person_abc",
        "customFieldId" => "cf_abc",
        "value" => "M"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-values"

        {:ok, %{status: 201, body: Map.put(params, "id", "cv_new")}}
      end)

      assert {:ok, response} = Humaans.CustomValues.create(client, params)
      assert response.id == "cv_new"
      assert response.value == "M"
    end
  end

  describe "retrieve/2" do
    test "retrieves a custom value", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-values/cv_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "cv_abc",
             "personId" => "person_abc",
             "customFieldId" => "cf_abc",
             "resourceId" => "res_abc",
             "value" => "M",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CustomValues.retrieve(client, "cv_abc")
      assert response.id == "cv_abc"
      assert response.person_id == "person_abc"
      assert response.custom_field_id == "cf_abc"
      assert response.resource_id == "res_abc"
      assert response.value == "M"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-01 14:52:21.000Z]
    end
  end

  describe "update/3" do
    test "updates a custom value", %{client: client} do
      params = %{"value" => "L"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-values/cv_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "cv_abc",
             "personId" => "person_abc",
             "customFieldId" => "cf_abc",
             "resourceId" => "res_abc",
             "value" => "L",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CustomValues.update(client, "cv_abc", params)
      assert response.id == "cv_abc"
      assert response.person_id == "person_abc"
      assert response.custom_field_id == "cf_abc"
      assert response.resource_id == "res_abc"
      assert response.value == "L"
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
      assert response.updated_at == ~U[2025-01-02 08:44:42.000Z]
    end
  end

  describe "delete/2" do
    test "deletes a custom value", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/custom-values/cv_abc"

        {:ok, %{status: 200, body: %{"id" => "cv_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "cv_abc", deleted: true}} =
               Humaans.CustomValues.delete(client, "cv_abc")
    end
  end
end
