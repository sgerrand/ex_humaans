defmodule Humaans.CompaniesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Companies

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of companies", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/companies"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "uoWtfpDIMI2IZ8doGK7kkCwS",
                 "name" => "Acme",
                 "domains" => [],
                 "trialEndDate" => "2020-01-30",
                 "status" => "active",
                 "paymentStatus" => "ok",
                 "package" => "growth",
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z",
                 "isTimesheetEnabled" => true
               }
             ]
           }
         }}
      end)

      assert {:ok, [response] = responses} = Humaans.Companies.list(client)
      assert length(responses) == 1
      assert response.id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert response.name == "Acme"
      assert response.domains == []
      assert response.trial_end_date == "2020-01-30"
      assert response.status == "active"
      assert response.payment_status == "ok"
      assert response.package == "growth"
      assert response.is_timesheet_enabled == true
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} ==
               Humaans.Companies.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.Companies.list(client)
    end
  end

  describe "retrieve/1" do
    test "retrieves a company", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/companies/123"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "uoWtfpDIMI2IZ8doGK7kkCwS",
             "name" => "Acme",
             "domains" => [],
             "trialEndDate" => "2020-01-30",
             "status" => "active",
             "paymentStatus" => "ok",
             "package" => "growth",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z",
             "isTimesheetEnabled" => true
           }
         }}
      end)

      assert {:ok, response} = Humaans.Companies.get(client, "123")
      assert response.id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert response.name == "Acme"
      assert response.domains == []
      assert response.trial_end_date == "2020-01-30"
      assert response.status == "active"
      assert response.payment_status == "ok"
      assert response.package == "growth"
      assert response.is_timesheet_enabled == true
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a company", %{client: client} do
      params = %{"name" => "Meac"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/companies/123"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "uoWtfpDIMI2IZ8doGK7kkCwS",
             "name" => "Meac",
             "domains" => [],
             "trialEndDate" => "2020-01-30",
             "status" => "active",
             "paymentStatus" => "ok",
             "package" => "growth",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z",
             "isTimesheetEnabled" => true
           }
         }}
      end)

      assert {:ok, response} = Humaans.Companies.update(client, "123", params)
      assert response.id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert response.name == "Meac"
      assert response.domains == []
      assert response.trial_end_date == "2020-01-30"
      assert response.status == "active"
      assert response.payment_status == "ok"
      assert response.package == "growth"
      assert response.is_timesheet_enabled == true
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end
end
