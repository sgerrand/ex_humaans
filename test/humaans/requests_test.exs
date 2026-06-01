defmodule Humaans.RequestsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Requests

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of requests", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/requests"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "req_abc",
                 "companyId" => "company_abc",
                 "personId" => "person_abc",
                 "requestTypeId" => "rt_abc",
                 "status" => "pending",
                 "data" => %{"foo" => "bar"},
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Requests.list(client)
      assert response.id == "req_abc"
      assert response.request_type_id == "rt_abc"
      assert response.status == "pending"
      assert response.data == %{"foo" => "bar"}
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Requests.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Requests.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a request", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/requests/req_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "req_abc",
             "status" => "pending",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Requests.retrieve(client, "req_abc")
      assert response.status == "pending"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.Requests, :create, 2)
    refute function_exported?(Humaans.Requests, :update, 3)
    refute function_exported?(Humaans.Requests, :delete, 2)
  end
end
