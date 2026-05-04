defmodule Humaans.AuditEventsTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.AuditEvents

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "retrieve/2" do
    test "retrieves an audit event", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/audit-events/ae_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ae_abc",
             "companyId" => "company_abc",
             "seq" => "42",
             "ts" => "2025-01-01T08:44:42.000Z",
             "request" => %{
               "id" => "req_abc",
               "path" => "/api/people",
               "method" => "POST",
               "ip" => "1.2.3.4"
             },
             "action" => "create",
             "actor" => %{"personId" => "person_def"},
             "entity" => %{"id" => "person_abc", "fieldsChanged" => ["firstName"]},
             "subject" => %{}
           }
         }}
      end)

      assert {:ok, response} = Humaans.AuditEvents.retrieve(client, "ae_abc")
      assert response.id == "ae_abc"
      assert response.company_id == "company_abc"
      assert response.seq == "42"
      assert response.ts == ~U[2025-01-01 08:44:42.000Z]
      assert response.action == "create"
      assert response.actor == %{"personId" => "person_def"}
      assert response.entity["fieldsChanged"] == ["firstName"]
    end

    test "returns error when not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.AuditEvents.retrieve(client, "ae_missing")
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _, _ ->
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.AuditEvents.retrieve(client, "ae_abc")
    end
  end

  test "non-retrieve actions are not exported" do
    refute function_exported?(Humaans.AuditEvents, :list, 2)
    refute function_exported?(Humaans.AuditEvents, :create, 2)
    refute function_exported?(Humaans.AuditEvents, :update, 3)
    refute function_exported?(Humaans.AuditEvents, :delete, 2)
  end
end
