defmodule Humaans.RequestCommentsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.RequestComments

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of request comments", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/request-comments"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "rc_abc",
                 "requestId" => "req_abc",
                 "personId" => "person_def",
                 "body" => "Approved.",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.RequestComments.list(client)
      assert response.request_id == "req_abc"
      assert response.body == "Approved."
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.RequestComments.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.RequestComments.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a request comment", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/request-comments/rc_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "rc_abc",
             "body" => "Approved.",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.RequestComments.retrieve(client, "rc_abc")
      assert response.body == "Approved."
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.RequestComments, :create, 2)
    refute function_exported?(Humaans.RequestComments, :update, 3)
    refute function_exported?(Humaans.RequestComments, :delete, 2)
  end
end
