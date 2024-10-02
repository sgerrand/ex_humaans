defmodule Humaans.CompensationsTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.Compensations

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of compensation types" do
      expect(Humaans.MockClient, :get, fn path, _params ->
        assert path == "/compensations"

        {:ok,
         %{
           status: 200,
           body: %{
             total: 1,
             limit: 100,
             skip: 0,
             data: [
               %{
                 id: "m54mmpqDwthFwiiMcY0ptJdz",
                 personId: "IL3vneCYhIx0xrR6um2sy2nW",
                 compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
                 amount: "70000",
                 currency: "EUR",
                 period: "annual",
                 note: "Promotion",
                 effectiveDate: "2020-02-15",
                 endDate: nil,
                 endReason: nil,
                 createdAt: "2020-01-28T08:44:42.000Z",
                 updatedAt: "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, response} = Humaans.Compensations.list()
      assert length(response) == 1
      assert hd(response).id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert hd(response).person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert hd(response).compensation_type_id == "aejf1oD4bZWNtEEnbFwrYGVg"
      assert hd(response).amount == "70000"
      assert hd(response).currency == "EUR"
      assert hd(response).period == "annual"
      assert hd(response).note == "Promotion"
      assert hd(response).effective_date == "2020-02-15"
      assert hd(response).end_date == nil
      assert hd(response).end_reason == nil
      assert hd(response).created_at == "2020-01-28T08:44:42.000Z"
      assert hd(response).updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "create/1" do
    test "creates a new compensation type" do
      params = %{
        personId: "IL3vneCYhIx0xrR6um2sy2nW",
        compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
        amount: "70000",
        currency: "EUR",
        period: "annual",
        effectiveDate: "2020-02-15"
      }

      expect(Humaans.MockClient, :post, fn path, ^params ->
        assert path == "/compensations"

        {:ok,
         %{
           status: 201,
           body: %{
             id: "m54mmpqDwthFwiiMcY0ptJdz",
             personId: "IL3vneCYhIx0xrR6um2sy2nW",
             compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
             amount: "70000",
             currency: "EUR",
             period: "annual",
             note: nil,
             effectiveDate: "2020-02-15",
             endDate: nil,
             endReason: nil,
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Compensations.create(params)
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
    test "retrieves a compensation type" do
      expect(Humaans.MockClient, :get, fn path ->
        assert path == "/compensations/m54mmpqDwthFwiiMcY0ptJdz"

        {:ok,
         %{
           status: 200,
           body: %{
             id: "m54mmpqDwthFwiiMcY0ptJdz",
             personId: "IL3vneCYhIx0xrR6um2sy2nW",
             compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
             amount: "70000",
             currency: "EUR",
             period: "annual",
             note: "Promotion",
             effectiveDate: "2020-02-15",
             endDate: nil,
             endReason: nil,
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Compensations.retrieve("m54mmpqDwthFwiiMcY0ptJdz")
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
    test "updates a compensation type" do
      params = %{
        compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
        amount: "70000",
        currency: "EUR",
        period: "annual",
        note: "Promotion",
        effectiveDate: "2020-02-15"
      }

      expect(Humaans.MockClient, :patch, fn path, ^params ->
        assert path == "/compensations/m54mmpqDwthFwiiMcY0ptJdz"

        {:ok,
         %{
           status: 200,
           body: %{
             id: "m54mmpqDwthFwiiMcY0ptJdz",
             personId: "IL3vneCYhIx0xrR6um2sy2nW",
             compensationTypeId: "aejf1oD4bZWNtEEnbFwrYGVg",
             amount: "70000",
             currency: "EUR",
             period: "annual",
             note: "Promotion",
             effectiveDate: "2020-02-15",
             endDate: nil,
             endReason: nil,
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.Compensations.update("m54mmpqDwthFwiiMcY0ptJdz", params)

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
    test "deletes a compensation type" do
      expect(Humaans.MockClient, :delete, fn path ->
        assert path == "/compensations/m54mmpqDwthFwiiMcY0ptJdz"

        {:ok, %{status: 200, body: %{id: "m54mmpqDwthFwiiMcY0ptJdz", deleted: true}}}
      end)

      assert {:ok, response} = Humaans.Compensations.delete("m54mmpqDwthFwiiMcY0ptJdz")
      assert response.id == "m54mmpqDwthFwiiMcY0ptJdz"
      assert response.deleted == true
    end
  end
end
