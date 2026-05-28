defmodule Humaans.EsignBulksTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.EsignBulks

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of esign bulks", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-bulks"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "eb_abc",
                 "companyId" => "company_abc",
                 "esignTemplateId" => "et_abc",
                 "name" => "Q1 Offer Letters",
                 "status" => "sent",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.EsignBulks.list(client)
      assert response.name == "Q1 Offer Letters"
      assert response.esign_template_id == "et_abc"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.EsignBulks.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.EsignBulks.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves an esign bulk", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-bulks/eb_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "eb_abc",
             "name" => "Q1 Offer Letters",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EsignBulks.retrieve(client, "eb_abc")
      assert response.name == "Q1 Offer Letters"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.EsignBulks, :create, 2)
    refute function_exported?(Humaans.EsignBulks, :update, 3)
    refute function_exported?(Humaans.EsignBulks, :delete, 2)
  end
end
