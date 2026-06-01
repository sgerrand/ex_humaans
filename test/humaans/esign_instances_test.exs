defmodule Humaans.EsignInstancesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.EsignInstances

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of esign instances", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-instances"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ei_abc",
                 "companyId" => "company_abc",
                 "esignTemplateId" => "et_abc",
                 "personId" => "person_abc",
                 "status" => "signed",
                 "signedAt" => "2025-01-15T08:44:42.000Z",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-15T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.EsignInstances.list(client)
      assert response.esign_template_id == "et_abc"
      assert response.status == "signed"
      assert response.signed_at == ~U[2025-01-15 08:44:42.000Z]
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.EsignInstances.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.EsignInstances.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves an esign instance", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/esign-instances/ei_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ei_abc",
             "esignTemplateId" => "et_abc",
             "status" => "signed",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-15T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.EsignInstances.retrieve(client, "ei_abc")
      assert response.esign_template_id == "et_abc"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.EsignInstances, :create, 2)
    refute function_exported?(Humaans.EsignInstances, :update, 3)
    refute function_exported?(Humaans.EsignInstances, :delete, 2)
  end
end
