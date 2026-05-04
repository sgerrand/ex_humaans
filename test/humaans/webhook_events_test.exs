defmodule Humaans.WebhookEventsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.WebhookEvents

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of webhook events", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhook-events"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "we_abc",
                 "webhookId" => "wh_abc",
                 "event" => "person.created",
                 "data" => %{"id" => "person_abc"},
                 "status" => "delivered",
                 "timestamp" => "2025-01-01T08:44:42.000Z",
                 "createdAt" => "2025-01-01T08:44:42.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.WebhookEvents.list(client)
      assert response.id == "we_abc"
      assert response.webhook_id == "wh_abc"
      assert response.event == "person.created"
      assert response.data == %{"id" => "person_abc"}
      assert response.status == "delivered"
      assert response.timestamp == ~U[2025-01-01 08:44:42.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.WebhookEvents.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ -> {:error, "boom"} end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.WebhookEvents.list(client)
    end
  end

  describe "retrieve/2" do
    test "retrieves a webhook event", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, opts ->
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhook-events/we_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "we_abc",
             "webhookId" => "wh_abc",
             "event" => "person.created",
             "createdAt" => "2025-01-01T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.WebhookEvents.retrieve(client, "we_abc")
      assert response.event == "person.created"
    end
  end

  test "write actions are not exported" do
    refute function_exported?(Humaans.WebhookEvents, :create, 2)
    refute function_exported?(Humaans.WebhookEvents, :update, 3)
    refute function_exported?(Humaans.WebhookEvents, :delete, 2)
  end
end
