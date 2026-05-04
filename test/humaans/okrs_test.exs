defmodule Humaans.OKRsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.OKRs

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of OKRs", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/okrs"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "okr_abc",
                 "companyId" => "company_abc",
                 "personId" => "person_abc",
                 "title" => "Ship feature X",
                 "description" => "By end of Q1",
                 "progress" => 0.5,
                 "status" => "in_progress",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.OKRs.list(client)
      assert response.id == "okr_abc"
      assert response.title == "Ship feature X"
      assert response.progress == 0.5
      assert response.status == "in_progress"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.OKRs.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.OKRs.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves an OKR", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/okrs/okr_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "okr_abc",
             "title" => "Ship feature X",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.OKRs.retrieve(client, "okr_abc")
      assert response.title == "Ship feature X"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.OKRs, :create, 2)
    refute function_exported?(Humaans.OKRs, :update, 3)
    refute function_exported?(Humaans.OKRs, :delete, 2)
  end
end
