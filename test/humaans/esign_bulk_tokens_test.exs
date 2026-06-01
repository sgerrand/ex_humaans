defmodule Humaans.EsignBulkTokensTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.EsignBulkTokens

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of esign bulk tokens", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-bulk-tokens"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ebt_abc",
                 "esignBulkRecipientId" => "ebr_abc",
                 "token" => "tok_xyz",
                 "expiresAt" => "2025-02-01T08:44:42.000Z",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.EsignBulkTokens.list(client)
      assert response.esign_bulk_recipient_id == "ebr_abc"
      assert response.token == "tok_xyz"
      assert response.expires_at == ~U[2025-02-01 08:44:42.000Z]
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.EsignBulkTokens.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.EsignBulkTokens.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves an esign bulk token", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/esign-bulk-tokens/ebt_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ebt_abc",
             "token" => "tok_xyz",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EsignBulkTokens.retrieve(client, "ebt_abc")
      assert response.token == "tok_xyz"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.EsignBulkTokens, :create, 2)
    refute function_exported?(Humaans.EsignBulkTokens, :update, 3)
    refute function_exported?(Humaans.EsignBulkTokens, :delete, 2)
  end
end
