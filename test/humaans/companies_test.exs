defmodule Humaans.CompaniesTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.Companies

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of companies" do
      expect(Humaans.MockClient, :get, fn path, _params ->
        assert path == "/companies"

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

      assert {:ok, response} = Humaans.Companies.list()
      assert length(response) == 1
      assert hd(response).id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert hd(response).name == "Acme"
      assert hd(response).domains == []
      assert hd(response).trial_end_date == "2020-01-30"
      assert hd(response).status == "active"
      assert hd(response).payment_status == "ok"
      assert hd(response).package == "growth"
      assert hd(response).is_timesheet_enabled == true
      assert hd(response).created_at == "2020-01-28T08:44:42.000Z"
      assert hd(response).updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found" do
      expect(Humaans.MockClient, :get, fn _path, _params ->
        {:ok, %{status: 404, body: %{"error" => "Company not found"}}}
      end)

      assert {:error, {404, %{"error" => "Company not found"}}} ==
               Humaans.Companies.list()
    end

    test "returns error when request fails" do
      expect(Humaans.MockClient, :get, fn _path, _params ->
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.Companies.list()
    end
  end

  describe "retrieve/1" do
    test "retrieves a company" do
      expect(Humaans.MockClient, :get, fn path ->
        assert path == "/companies/123"

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

      assert {:ok, response} = Humaans.Companies.get("123")
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
    test "updates a company" do
      params = %{"name" => "Meac"}

      expect(Humaans.MockClient, :patch, fn path, ^params ->
        assert path == "/companies/123"

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

      assert {:ok, response} = Humaans.Companies.update("123", params)
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
