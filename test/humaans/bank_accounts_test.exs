defmodule Humaans.BankAccountsTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.BankAccounts

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of bank accounts" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, path, _params ->
        assert client_param == client
        assert path == "/bank-accounts"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "Ivl8mvdLO8ux7T1h1DjGtClc",
                 "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
                 "bankName" => "Mondo",
                 "nameOnAccount" => "Kelsey Wicks",
                 "accountNumber" => "12345678",
                 "swiftCode" => nil,
                 "sortCode" => "00-00-00",
                 "routingNumber" => nil,
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.list(client)
      assert length(response) == 1
      assert hd(response).id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert hd(response).person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert hd(response).bank_name == "Mondo"
      assert hd(response).name_on_account == "Kelsey Wicks"
      assert hd(response).account_number == "12345678"
      assert hd(response).swift_code == nil
      assert hd(response).sort_code == "00-00-00"
      assert hd(response).routing_number == nil
      assert hd(response).created_at == "2020-01-28T08:44:42.000Z"
      assert hd(response).updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, _path, _params ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Bank Account not found"}}}
      end)

      assert {:error, {404, %{"error" => "Bank Account not found"}}} ==
               Humaans.BankAccounts.list(client)
    end

    test "returns error when request fails" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, _path, _params ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.BankAccounts.list(client)
    end
  end

  describe "create/1" do
    test "creates a new bank account" do
      client = %{req: Req.new()}

      params = %{
        "personId" => "123",
        "bankName" => "New Bank",
        "accountNumber" => "12345678"
      }

      expect(Humaans.MockClient, :post, fn client_param, path, ^params ->
        assert client_param == client
        assert path == "/bank-accounts"

        {:ok,
         %{
           status: 201,
           body: Map.put(params, "id", "new_id")
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.create(client, params)
      assert response.id == "new_id"
      assert response.bank_name == "New Bank"
      assert response.account_number == "12345678"
    end
  end

  describe "retrieve/1" do
    test "retrieves a bank account" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, path ->
        assert client_param == client
        assert path == "/bank-accounts/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "Ivl8mvdLO8ux7T1h1DjGtClc",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "bankName" => "Mondo",
             "nameOnAccount" => "Kelsey Wicks",
             "accountNumber" => "12345678",
             "swiftCode" => nil,
             "sortCode" => "00-00-00",
             "routingNumber" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.BankAccounts.retrieve(client, "Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.bank_name == "Mondo"
      assert response.name_on_account == "Kelsey Wicks"
      assert response.account_number == "12345678"
      assert response.swift_code == nil
      assert response.sort_code == "00-00-00"
      assert response.routing_number == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a bank account" do
      client = %{req: Req.new()}
      params = %{"bankName" => "N1"}

      expect(Humaans.MockClient, :patch, fn client_param, path, ^params ->
        assert client_param == client
        assert path == "/bank-accounts/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "Ivl8mvdLO8ux7T1h1DjGtClc",
             "personId" => "IL3vneCYhIx0xrR6um2sy2nW",
             "bankName" => "N1",
             "nameOnAccount" => "Kelsey Wicks",
             "accountNumber" => "12345678",
             "swiftCode" => nil,
             "sortCode" => "00-00-00",
             "routingNumber" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.BankAccounts.update(client, "Ivl8mvdLO8ux7T1h1DjGtClc", params)

      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.person_id == "IL3vneCYhIx0xrR6um2sy2nW"
      assert response.bank_name == "N1"
      assert response.name_on_account == "Kelsey Wicks"
      assert response.account_number == "12345678"
      assert response.swift_code == nil
      assert response.sort_code == "00-00-00"
      assert response.routing_number == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a bank account" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :delete, fn client_param, path ->
        assert client_param == client
        assert path == "/bank-accounts/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok, %{status: 200, body: %{"id" => "Ivl8mvdLO8ux7T1h1DjGtClc", "deleted" => true}}}
      end)

      assert {:ok, response} = Humaans.BankAccounts.delete(client, "Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.deleted == true
    end
  end
end
