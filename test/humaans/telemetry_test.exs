defmodule Humaans.TelemetryTest do
  use ExUnit.Case, async: false

  setup do
    client = Humaans.new(access_token: "test-token", http_client: Humaans.MockHTTPClient)
    {:ok, client: client}
  end

  describe "[:humaans, :request, :start]" do
    test "is emitted before the request", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      ref = :telemetry_test.attach_event_handlers(self(), [[:humaans, :request, :start]])

      Humaans.People.list(client)

      assert_receive {[:humaans, :request, :start], ^ref, measurements, metadata}
      assert is_integer(measurements.system_time)
      assert is_integer(measurements.monotonic_time)
      assert metadata.method == :get
      assert metadata.path == "/people"
      assert String.ends_with?(metadata.url, "/people")
    end
  end

  describe "[:humaans, :request, :stop]" do
    test "is emitted after a successful request", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      ref = :telemetry_test.attach_event_handlers(self(), [[:humaans, :request, :stop]])

      Humaans.People.list(client)

      assert_receive {[:humaans, :request, :stop], ^ref, measurements, metadata}
      assert is_integer(measurements.duration)
      assert measurements.duration > 0
      assert metadata.method == :get
      assert metadata.path == "/people"
      assert metadata.status == 200
    end

    test "includes status for non-2xx responses", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 404, body: %{"error" => "not found"}}}
      end)

      ref = :telemetry_test.attach_event_handlers(self(), [[:humaans, :request, :stop]])

      Humaans.People.retrieve(client, "missing")

      assert_receive {[:humaans, :request, :stop], ^ref, _measurements, metadata}
      assert metadata.status == 404
    end

    test "includes error: true for network errors", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:error, :econnrefused}
      end)

      ref = :telemetry_test.attach_event_handlers(self(), [[:humaans, :request, :stop]])

      Humaans.People.list(client)

      assert_receive {[:humaans, :request, :stop], ^ref, _measurements, metadata}
      assert metadata.error == true
    end

    test "is emitted for POST requests", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 201, body: %{"id" => "new-id", "firstName" => "Jane"}}}
      end)

      ref = :telemetry_test.attach_event_handlers(self(), [[:humaans, :request, :stop]])

      Humaans.People.create(client, %{"firstName" => "Jane"})

      assert_receive {[:humaans, :request, :stop], ^ref, _measurements, metadata}
      assert metadata.method == :post
      assert metadata.path == "/people"
      assert metadata.status == 201
    end
  end
end
