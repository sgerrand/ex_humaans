defmodule Humaans.PerformanceReviewsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PerformanceReviews

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of performance reviews", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/performance-reviews"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "pr_abc",
                 "companyId" => "company_abc",
                 "personId" => "person_abc",
                 "performanceInstanceId" => "pi_abc",
                 "status" => "submitted",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.PerformanceReviews.list(client)
      assert response.id == "pr_abc"
      assert response.performance_instance_id == "pi_abc"
      assert response.status == "submitted"
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PerformanceReviews.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PerformanceReviews.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a performance review", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/performance-reviews/pr_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "pr_abc",
             "performanceInstanceId" => "pi_abc",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.PerformanceReviews.retrieve(client, "pr_abc")
      assert response.performance_instance_id == "pi_abc"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.PerformanceReviews, :create, 2)
    refute function_exported?(Humaans.PerformanceReviews, :update, 3)
    refute function_exported?(Humaans.PerformanceReviews, :delete, 2)
  end
end
