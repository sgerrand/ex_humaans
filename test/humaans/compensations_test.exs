defmodule Humaans.CompensationsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Compensations

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of compensations", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/compensations"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "m54mmpqDwthFwiiMcY0ptJdz",
                 "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
                 "compensationTypeId" => "aejf1oD4bZWNtEEnbFwrYGVg",
                 "amount" => "70000",
                 "currency" => "EUR",
                 "period" => "annual",
                 "note" => "Promotion",
                 "effectiveDate" => "2020-02-15",
                 "endDate" => nil,
                 "endReason" => nil,
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response] = responses} = Humaans.Compensations.list(client)
      assert length(responses) == 1
      assert response.id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.compensation_type_id == "aejf1oD4bZWNtEEnbFwrYGVg"
      assert response.amount == "70000"
      assert response.currency == "EUR"
      assert response.period == "annual"
      assert response.note == "Promotion"
      assert response.effective_date == "2020-02-15"
      assert response.end_date == nil
      assert response.end_reason == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Compensation not found"}}}
      end)

      assert {:error, {404, %{"error" => "Compensation not found"}}} ==
               Humaans.Compensations.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.Compensations.list(client)
    end
  end

  describe "create/1" do
    test "creates a new compensation", %{client: client} do
      params = %{
        personId: "IL3vneCYhIx0xrR6um2sy2nW",
        compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
        amount: "70000",
        currency: "EUR",
        period: "annual",
        effectiveDate: "2020-02-15"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/compensations"

        {:ok,
         %{
           status: 201,
           body: %{
             "id" => "m54mmpqDwthFwiiMcY0ptJdz",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "compensationTypeId" => "aejf1oD4bZWNtEEnbFwrYGVg",
             "amount" => "70000",
             "currency" => "EUR",
             "period" => "annual",
             "note" => nil,
             "effectiveDate" => "2020-02-15",
             "endDate" => nil,
             "endReason" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Compensations.create(client, params)
      assert response.id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.compensation_type_id == "aejf1oD4bZWNtEEnbFwrYGVg"
      assert response.amount == "70000"
      assert response.currency == "EUR"
      assert response.period == "annual"
      assert response.note == nil
      assert response.effective_date == "2020-02-15"
      assert response.end_date == nil
      assert response.end_reason == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "retrieve/1" do
    test "retrieves a compensation", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/compensations/m54mmpqDwthFwiiMcY0ptJdz"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "m54mmpqDwthFwiiMcY0ptJdz",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "compensationTypeId" => "aejf1oD4bZWNtEEnbFwrYGVg",
             "amount" => "70000",
             "currency" => "EUR",
             "period" => "annual",
             "note" => "Promotion",
             "effectiveDate" => "2020-02-15",
             "endDate" => nil,
             "endReason" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Compensations.retrieve(client, "m54mmpqDwthFwiiMcY0ptJdz")
      assert response.id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.compensation_type_id == "aejf1oD4bZWNtEEnbFwrYGVg"
      assert response.amount == "70000"
      assert response.currency == "EUR"
      assert response.period == "annual"
      assert response.note == "Promotion"
      assert response.effective_date == "2020-02-15"
      assert response.end_date == nil
      assert response.end_reason == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a compensation", %{client: client} do
      params = %{
        compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
        amount: "70000",
        currency: "EUR",
        period: "annual",
        note: "Promotion",
        effectiveDate: "2020-02-15"
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/compensations/m54mmpqDwthFwiiMcY0ptJdz"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "m54mmpqDwthFwiiMcY0ptJdz",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "compensationTypeId" => "aejf1oD4bZWNtEEnbFwrYGVg",
             "amount" => "70000",
             "currency" => "EUR",
             "period" => "annual",
             "note" => "Promotion",
             "effectiveDate" => "2020-02-15",
             "endDate" => nil,
             "endReason" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.Compensations.update(client, "m54mmpqDwthFwiiMcY0ptJdz", params)

      assert response.id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.compensation_type_id == "aejf1oD4bZWNtEEnbFwrYGVg"
      assert response.amount == "70000"
      assert response.currency == "EUR"
      assert response.period == "annual"
      assert response.note == "Promotion"
      assert response.effective_date == "2020-02-15"
      assert response.end_date == nil
      assert response.end_reason == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a compensation", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :headers) == [{"Accept", "application/json"}]
        assert Keyword.fetch!(opts, :method) == :delete

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/compensations/m54mmpqDwthFwiiMcY0ptJdz"

        {:ok, %{status: 200, body: %{"id" => "m54mmpqDwthFwiiMcY0ptJdz", "deleted" => true}}}
      end)

      assert {:ok, response} = Humaans.Compensations.delete(client, "m54mmpqDwthFwiiMcY0ptJdz")
      assert response.id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert response.deleted == true
    end
  end
end
