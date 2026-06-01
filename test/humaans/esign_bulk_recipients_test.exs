defmodule Humaans.EsignBulkRecipientsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.EsignBulkRecipients

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of esign bulk recipients", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-bulk-recipients"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ebr_abc",
                 "esignBulkId" => "eb_abc",
                 "personId" => "person_abc",
                 "status" => "pending",
                 "signedAt" => nil,
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.EsignBulkRecipients.list(client)
      assert response.esign_bulk_id == "eb_abc"
      assert response.status == "pending"
      assert response.signed_at == nil
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.EsignBulkRecipients.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.EsignBulkRecipients.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves an esign bulk recipient", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/esign-bulk-recipients/ebr_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ebr_abc",
             "esignBulkId" => "eb_abc",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EsignBulkRecipients.retrieve(client, "ebr_abc")
      assert response.esign_bulk_id == "eb_abc"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.EsignBulkRecipients, :create, 2)
    refute function_exported?(Humaans.EsignBulkRecipients, :update, 3)
    refute function_exported?(Humaans.EsignBulkRecipients, :delete, 2)
  end
end
