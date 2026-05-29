defmodule Humaans.WebhooksTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.Webhooks

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  @secret "shhh-very-secret"
  @body ~s({"event":"person.updated","data":{"id":"abc"}})

  defp signature_for(body, secret) do
    :crypto.mac(:hmac, :sha256, secret, body)
    |> Base.encode16(case: :lower)
  end

  describe "verify_signature/3" do
    test "returns :ok for a valid signature" do
      sig = signature_for(@body, @secret)
      assert Humaans.Webhooks.verify_signature(@body, sig, @secret) == :ok
    end

    test "accepts a sha256= prefixed signature" do
      sig = "sha256=" <> signature_for(@body, @secret)
      assert Humaans.Webhooks.verify_signature(@body, sig, @secret) == :ok
    end

    test "accepts an uppercase SHA256= prefixed signature" do
      sig = "SHA256=" <> signature_for(@body, @secret)
      assert Humaans.Webhooks.verify_signature(@body, sig, @secret) == :ok
    end

    test "accepts a mixed-case Sha256= prefixed signature" do
      sig = "Sha256=" <> signature_for(@body, @secret)
      assert Humaans.Webhooks.verify_signature(@body, sig, @secret) == :ok
    end

    test "is case-insensitive on the hex digest" do
      sig = signature_for(@body, @secret) |> String.upcase()
      assert Humaans.Webhooks.verify_signature(@body, sig, @secret) == :ok
    end

    test "rejects a tampered body" do
      sig = signature_for(@body, @secret)
      tampered = @body <> " "

      assert Humaans.Webhooks.verify_signature(tampered, sig, @secret) ==
               {:error, :invalid_signature}
    end

    test "rejects a wrong secret" do
      sig = signature_for(@body, @secret)

      assert Humaans.Webhooks.verify_signature(@body, sig, "wrong-secret") ==
               {:error, :invalid_signature}
    end

    test "rejects mismatched length signatures without raising" do
      assert Humaans.Webhooks.verify_signature(@body, "deadbeef", @secret) ==
               {:error, :invalid_signature}
    end

    test "returns :missing_signature for nil signature" do
      assert Humaans.Webhooks.verify_signature(@body, nil, @secret) ==
               {:error, :missing_signature}
    end

    test "returns :missing_signature for empty signature" do
      assert Humaans.Webhooks.verify_signature(@body, "", @secret) ==
               {:error, :missing_signature}
    end

    test "returns :missing_secret for nil secret" do
      sig = signature_for(@body, @secret)

      assert Humaans.Webhooks.verify_signature(@body, sig, nil) ==
               {:error, :missing_secret}
    end

    test "returns :missing_secret for empty secret" do
      sig = signature_for(@body, @secret)

      assert Humaans.Webhooks.verify_signature(@body, sig, "") ==
               {:error, :missing_secret}
    end
  end

  describe "list/1" do
    test "returns a list of webhooks", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhooks"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "wh_abc",
                 "companyId" => "company_abc",
                 "url" => "https://example.com/hooks",
                 "events" => ["person.created", "person.updated"],
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.Webhooks.list(client)
      assert response.id == "wh_abc"
      assert response.company_id == "company_abc"
      assert response.url == "https://example.com/hooks"
      assert response.events == ["person.created", "person.updated"]
      assert response.created_at == ~U[2025-01-01 08:44:42.000Z]
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.Webhooks.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.Webhooks.list(client)
    end
  end

  describe "create/2" do
    test "creates a webhook", %{client: client} do
      params = %{
        "url" => "https://example.com/hooks",
        "events" => ["person.created"]
      }

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhooks"

        {:ok, %{status: 201, body: Map.put(params, "id", "wh_new")}}
      end)

      assert {:ok, response} = Humaans.Webhooks.create(client, params)
      assert response.id == "wh_new"
      assert response.url == "https://example.com/hooks"
      assert response.events == ["person.created"]
    end
  end

  describe "retrieve/2" do
    test "retrieves a webhook", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhooks/wh_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "wh_abc",
             "url" => "https://example.com/hooks",
             "events" => ["person.created"],
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Webhooks.retrieve(client, "wh_abc")
      assert response.url == "https://example.com/hooks"
    end
  end

  describe "update/3" do
    test "updates a webhook", %{client: client} do
      params = %{"events" => ["person.created", "person.updated"]}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhooks/wh_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "wh_abc",
             "url" => "https://example.com/hooks",
             "events" => ["person.created", "person.updated"],
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.Webhooks.update(client, "wh_abc", params)
      assert response.events == ["person.created", "person.updated"]
    end
  end

  describe "delete/2" do
    test "deletes a webhook", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :delete
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/webhooks/wh_abc"

        {:ok, %{status: 200, body: %{"id" => "wh_abc", "deleted" => true}}}
      end)

      assert {:ok, %{id: "wh_abc", deleted: true}} =
               Humaans.Webhooks.delete(client, "wh_abc")
    end
  end
end
