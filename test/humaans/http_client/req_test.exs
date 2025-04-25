defmodule Humaans.HTTPClient.ReqTest do
  use ExUnit.Case, async: true

  alias Humaans.HTTPClient.Req, as: HumaansReq

  setup do
    client = %Humaans{
      access_token: "test-token",
      base_url: "https://app.humaans.io/api",
      http_client: HumaansReq
    }

    [client: client]
  end

  describe "request/2" do
    test "configures GET requests correctly without params", %{client: client} do
      response_body = %{"data" => [%{"id" => "123"}]}
      {response, request_opts} = setup_test(:get, "/people", response_body)

      request_opts = Keyword.put(request_opts, :base_url, client.base_url)

      result = HumaansReq.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures GET requests correctly with query params", %{client: client} do
      response_body = %{"data" => [%{"id" => "123"}]}

      {response, request_opts} =
        setup_test(:get, "/people", response_body, 200, params: [limit: 10, offset: 0])

      result = HumaansReq.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures POST requests correctly with JSON body", %{client: client} do
      response_body = %{"id" => "123", "name" => "Test User"}
      body = %{name: "Test User", email: "test@example.com"}
      {response, request_opts} = setup_test(:post, "/people", response_body, 201, body: body)

      result = HumaansReq.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures PATCH requests correctly", %{client: client} do
      response_body = %{"id" => "123", "name" => "Updated User"}
      body = %{name: "Updated User"}
      {response, request_opts} = setup_test(:patch, "/people/123", response_body, 200, body: body)

      result = HumaansReq.request(client, request_opts)

      assert result == {:ok, response}
    end

    test "configures DELETE requests correctly", %{client: client} do
      response_body = %{"id" => "123", "deleted" => true}
      {response, request_opts} = setup_test(:delete, "/people/123", response_body)

      result = HumaansReq.request(client, request_opts)

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

      result = HumaansReq.request(client, request_opts)

      assert result == {:error, error_response}
    end
  end

  defp setup_test(method, url, response_body, status \\ 200, extra_opts \\ []) do
    response = %Req.Response{status: status, body: response_body, headers: %{}}

    adapter = fn request ->
      {request, response}
    end

    request_opts =
      [
        method: method,
        url: url,
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ] ++ extra_opts

    {response, request_opts}
  end
end
