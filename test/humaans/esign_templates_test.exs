defmodule Humaans.EsignTemplatesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.EsignTemplates

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of esign templates", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-templates"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "et_abc",
                 "companyId" => "company_abc",
                 "name" => "Offer Letter",
                 "body" => "Welcome to Acme...",
                 "status" => "active",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.EsignTemplates.list(client)
      assert response.name == "Offer Letter"
      assert response.status == "active"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.EsignTemplates.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.EsignTemplates.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves an esign template", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-templates/et_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "et_abc",
             "name" => "Offer Letter",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EsignTemplates.retrieve(client, "et_abc")
      assert response.name == "Offer Letter"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.EsignTemplates, :create, 2)
    refute function_exported?(Humaans.EsignTemplates, :update, 3)
    refute function_exported?(Humaans.EsignTemplates, :delete, 2)
  end
end
