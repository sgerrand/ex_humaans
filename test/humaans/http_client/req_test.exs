defmodule Humaans.HTTPClient.ReqTest do
  use ExUnit.Case, async: true

  setup do
    client = %Humaans{
      access_token: "test-token",
      base_url: "https://app.humaans.io/api",
      http_client: Humaans.HTTPClient.Req
    }

    [client: client]
  end

  describe "request/2" do
    test "configures GET requests correctly without params", %{client: client} do
      response_body = %{"data" => [%{"id" => "123"}]}
      response = %Req.Response{status: 200, body: response_body, headers: %{}}

      adapter = fn request ->
        {request, response}
      end

      request_opts = [
        method: :get,
        base_url: client.base_url,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ]

      result = Humaans.HTTPClient.Req.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures GET requests correctly with query params", %{client: client} do
      response_body = %{"data" => [%{"id" => "123"}]}
      response = %Req.Response{status: 200, body: response_body, headers: %{}}

      adapter = fn request ->
        {request, response}
      end

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        params: [limit: 10, offset: 0],
        adapter: adapter
      ]

      result = Humaans.HTTPClient.Req.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures POST requests correctly with JSON body", %{client: client} do
      response_body = %{"id" => "123", "name" => "Test User"}
      response = %Req.Response{status: 201, body: response_body, headers: %{}}

      adapter = fn request ->
        {request, response}
      end

      body = %{name: "Test User", email: "test@example.com"}

      request_opts = [
        method: :post,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        body: body,
        adapter: adapter
      ]

      result = Humaans.HTTPClient.Req.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures PATCH requests correctly", %{client: client} do
      response_body = %{"id" => "123", "name" => "Updated User"}
      response = %Req.Response{status: 200, body: response_body, headers: %{}}

      adapter = fn request ->
        {request, response}
      end

      body = %{name: "Updated User"}

      request_opts = [
        method: :patch,
        url: "/people/123",
        headers: [{"Accept", "application/json"}],
        body: body,
        adapter: adapter
      ]

      result = Humaans.HTTPClient.Req.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures DELETE requests correctly", %{client: client} do
      response_body = %{"id" => "123", "deleted" => true}
      response = %Req.Response{status: 200, body: response_body, headers: %{}}

      adapter = fn request ->
        {request, response}
      end

      request_opts = [
        method: :delete,
        url: "/people/123",
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ]

      result = Humaans.HTTPClient.Req.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "handles error responses correctly", %{client: client} do
      error_response = RuntimeError.exception("connection_error")

      adapter = fn request ->
        {request, error_response}
      end

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ]

      result = Humaans.HTTPClient.Req.request(client, request_opts)

      assert result == {:error, error_response}
    end
  end
end
