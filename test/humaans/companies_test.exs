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
             total: 1,
             limit: 100,
             skip: 0,
             data: [
               %{
                 id: "uoWtfpDIMI2IZ8doGK7kkCwS",
                 name: "Acme",
                 domains: [],
                 trialEndDate: "2020-01-30",
                 status: "active",
                 paymentStatus: "ok",
                 package: "growth",
                 createdAt: "2020-01-28T08:44:42.000Z",
                 updatedAt: "2020-01-29T14:52:21.000Z",
                 isTimesheetEnabled: true
               }
             ]
           }
         }}
      end)

      assert {:ok, response} = Humaans.Companies.list()
      assert length(response[:data]) == 1
      assert hd(response[:data]).id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert hd(response[:data]).name == "Acme"
      assert hd(response[:data]).domains == []
      assert hd(response[:data]).trialEndDate == "2020-01-30"
      assert hd(response[:data]).status == "active"
      assert hd(response[:data]).paymentStatus == "ok"
      assert hd(response[:data]).package == "growth"
      assert hd(response[:data]).isTimesheetEnabled == true
      assert hd(response[:data]).createdAt == "2020-01-28T08:44:42.000Z"
      assert hd(response[:data]).updatedAt == "2020-01-29T14:52:21.000Z"
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
             id: "uoWtfpDIMI2IZ8doGK7kkCwS",
             name: "Acme",
             domains: [],
             trialEndDate: "2020-01-30",
             status: "active",
             paymentStatus: "ok",
             package: "growth",
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z",
             isTimesheetEnabled: true
           }
         }}
      end)

      assert {:ok, response} = Humaans.Companies.get("123")
      assert response.id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert response.name == "Acme"
      assert response.domains == []
      assert response.trialEndDate == "2020-01-30"
      assert response.status == "active"
      assert response.paymentStatus == "ok"
      assert response.package == "growth"
      assert response.isTimesheetEnabled == true
      assert response.createdAt == "2020-01-28T08:44:42.000Z"
      assert response.updatedAt == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a company" do
      params = %{"name" => "Meac"}

      expect(Humaans.MockClient, :patch, fn path, ^params ->
        assert path == "/companies/123"

        {:ok, %{status: 200, body: %{
             id: "uoWtfpDIMI2IZ8doGK7kkCwS",
             name: "Meac",
             domains: [],
             trialEndDate: "2020-01-30",
             status: "active",
             paymentStatus: "ok",
             package: "growth",
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z",
             isTimesheetEnabled: true
           }}}
      end)

      assert {:ok, response} = Humaans.Companies.update("123", params)
      assert response.id == "uoWtfpDIMI2IZ8doGK7kkCwS"
      assert response.name == "Meac"
      assert response.domains == []
      assert response.trialEndDate == "2020-01-30"
      assert response.status == "active"
      assert response.paymentStatus == "ok"
      assert response.package == "growth"
      assert response.isTimesheetEnabled == true
      assert response.createdAt == "2020-01-28T08:44:42.000Z"
      assert response.updatedAt == "2020-01-29T14:52:21.000Z"
    end
  end
end
