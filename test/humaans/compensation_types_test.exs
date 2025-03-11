defmodule Humaans.CompensationTypesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.CompensationTypes

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of compensation types", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/compensation-types"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
                 "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
                 "name" => "Salary",
                 "baseType" => "salary",
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response] = responses} = Humaans.CompensationTypes.list(client)
      assert length(responses) == 1
      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Compensation Type not found"}}}
      end)

      assert {:error, {404, %{"error" => "Compensation Type not found"}}} ==
               Humaans.CompensationTypes.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.CompensationTypes.list(client)
    end
  end

  describe "create/1" do
    test "creates a new compensation type", %{client: client} do
      params = %{
        "name" => "Salary"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/compensation-types"

        {:ok,
         %{
           status: 201,
           body: %{
             "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "name" => "Salary",
             "baseType" => "salary",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CompensationTypes.create(client, params)
      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "retrieve/1" do
    test "retrieves a compensation type", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/compensation-types/ldOQU3pLI5i8Y9k2rJbrXbFc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "name" => "Salary",
             "baseType" => "salary",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.CompensationTypes.retrieve(client, "ldOQU3pLI5i8Y9k2rJbrXbFc")

      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a compensation type", %{client: client} do
      params = %{"name" => "New Salary"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/compensation-types/ldOQU3pLI5i8Y9k2rJbrXbFc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "name" => "New Salary",
             "baseType" => "salary",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.CompensationTypes.update(client, "ldOQU3pLI5i8Y9k2rJbrXbFc", params)

      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "New Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a compensation type", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/compensation-types/ldOQU3pLI5i8Y9k2rJbrXbFc"

        {:ok, %{status: 200, body: %{"id" => "ldOQU3pLI5i8Y9k2rJbrXbFc", "deleted" => true}}}
      end)

      assert {:ok, response} =
               Humaans.CompensationTypes.delete(client, "ldOQU3pLI5i8Y9k2rJbrXbFc")

      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.deleted == true
    end
  end
end
