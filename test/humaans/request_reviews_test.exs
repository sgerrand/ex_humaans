defmodule Humaans.RequestReviewsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.RequestReviews

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of request reviews", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/request-reviews"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "rrev_abc",
                 "requestId" => "req_abc",
                 "reviewerId" => "person_def",
                 "status" => "pending",
                 "decision" => nil,
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.RequestReviews.list(client)
      assert response.request_id == "req_abc"
      assert response.reviewer_id == "person_def"
      assert response.status == "pending"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.RequestReviews.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.RequestReviews.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a request review", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/request-reviews/rrev_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "rrev_abc",
             "requestId" => "req_abc",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.RequestReviews.retrieve(client, "rrev_abc")
      assert response.request_id == "req_abc"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.RequestReviews, :create, 2)
    refute function_exported?(Humaans.RequestReviews, :update, 3)
    refute function_exported?(Humaans.RequestReviews, :delete, 2)
  end
end
