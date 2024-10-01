defmodule Humaans.BankAccountsTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.BankAccounts

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of bank accounts" do
      expect(Humaans.MockClient, :get, fn path, _params ->
        assert path == "/bank-accounts"

        {:ok,
         %{
           status: 200,
           body: %{
             total: 1,
             limit: 100,
             skip: 0,
             data: [
               %{
                 id: "Ivl8mvdLO8ux7T1h1DjGtClc",
                 personId: "IL3vneCYhIx0xrR6um2sy2nW",
                 bankName: "Mondo",
                 nameOnAccount: "Kelsey Wicks",
                 accountNumber: "12345678",
                 swiftCode: nil,
                 sortCode: "00-00-00",
                 routingNumber: nil,
                 createdAt: "2020-01-28T08:44:42.000Z",
                 updatedAt: "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.list()
      assert length(response.data) == 1
      assert hd(response.data).id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert hd(response.data).personId == "IL3vneCYhIx0xrR6um2sy2nW"
      assert hd(response.data).bankName == "Mondo"
      assert hd(response.data).nameOnAccount == "Kelsey Wicks"
      assert hd(response.data).accountNumber == "12345678"
      assert hd(response.data).swiftCode == nil
      assert hd(response.data).sortCode == "00-00-00"
      assert hd(response.data).routingNumber == nil
      assert hd(response.data).createdAt == "2020-01-28T08:44:42.000Z"
      assert hd(response.data).updatedAt == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "create/1" do
    test "creates a new bank account" do
      params = %{
        "personId" => "123",
        "bankName" => "New Bank",
        "accountNumber" => "12345678"
      }

      expect(Humaans.MockClient, :post, fn path, ^params ->
        assert path == "/bank-accounts"

        {:ok,
         %{
           status: 201,
           body: Map.put(params, "id", "new_id")
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.create(params)
      assert response["id"] == "new_id"
      assert response["bankName"] == "New Bank"
    end
  end

  describe "retrieve/1" do
    test "retrieves a bank account" do
      expect(Humaans.MockClient, :get, fn path ->
        assert path == "/bank-accounts/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok,
         %{
           status: 200,
           body: %{
             id: "Ivl8mvdLO8ux7T1h1DjGtClc",
             personId: "IL3vneCYhIx0xrR6um2sy2nW",
             bankName: "Mondo",
             nameOnAccount: "Kelsey Wicks",
             accountNumber: "12345678",
             swiftCode: nil,
             sortCode: "00-00-00",
             routingNumber: nil,
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.retrieve("Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.personId == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.bankName == "Mondo"
      assert response.nameOnAccount == "Kelsey Wicks"
      assert response.accountNumber == "12345678"
      assert response.swiftCode == nil
      assert response.sortCode == "00-00-00"
      assert response.routingNumber == nil
      assert response.createdAt == "2020-01-28T08:44:42.000Z"
      assert response.updatedAt == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a bank account" do
      params = %{"bankName" => "N1"}

      expect(Humaans.MockClient, :patch, fn path, ^params ->
        assert path == "/bank-accounts/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok,
         %{
           status: 200,
           body: %{
             id: "Ivl8mvdLO8ux7T1h1DjGtClc",
             personId: "IL3vneCYhIx0xrR6um2sy2nW",
             bankName: "N1",
             nameOnAccount: "Kelsey Wicks",
             accountNumber: "12345678",
             swiftCode: nil,
             sortCode: "00-00-00",
             routingNumber: nil,
             createdAt: "2020-01-28T08:44:42.000Z",
             updatedAt: "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.update("Ivl8mvdLO8ux7T1h1DjGtClc", params)
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.personId == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.bankName == "N1"
      assert response.nameOnAccount == "Kelsey Wicks"
      assert response.accountNumber == "12345678"
      assert response.swiftCode == nil
      assert response.sortCode == "00-00-00"
      assert response.routingNumber == nil
      assert response.createdAt == "2020-01-28T08:44:42.000Z"
      assert response.updatedAt == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a bank account" do
      expect(Humaans.MockClient, :delete, fn path ->
        assert path == "/bank-accounts/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok, %{status: 200, body: %{id: "Ivl8mvdLO8ux7T1h1DjGtClc", deleted: true}}}
      end)

      assert {:ok, response} = Humaans.BankAccounts.delete("Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.deleted == true
    end
  end
end
