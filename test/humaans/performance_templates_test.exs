defmodule Humaans.PerformanceTemplatesTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PerformanceTemplates

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of performance templates", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/performance-templates"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "pt_abc",
                 "companyId" => "company_abc",
                 "name" => "Engineering Review",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.PerformanceTemplates.list(client)
      assert response.name == "Engineering Review"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceTemplates.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PerformanceTemplates.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a performance template", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/performance-templates/pt_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "pt_abc",
             "name" => "Engineering Review",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.PerformanceTemplates.retrieve(client, "pt_abc")
      assert response.name == "Engineering Review"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.PerformanceTemplates, :create, 2)
    refute function_exported?(Humaans.PerformanceTemplates, :update, 3)
    refute function_exported?(Humaans.PerformanceTemplates, :delete, 2)
  end
end
