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

    test "configures PATCH requests without a body", %{client: client} do
      response_body = %{"id" => "123"}
      {response, request_opts} = setup_test(:patch, "/people/123", response_body)

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

    test "retries on 429 and eventually succeeds", %{client: client} do
      {:ok, counter} = Agent.start_link(fn -> 0 end)

      adapter = fn request ->
        n = Agent.get_and_update(counter, fn n -> {n + 1, n + 1} end)

        if n <= 2 do
          {request,
           %Req.Response{
             status: 429,
             body: %{"error" => "rate_limited"},
             headers: %{"retry-after" => ["0"]}
           }}
        else
          {request, %Req.Response{status: 200, body: %{"ok" => true}, headers: %{}}}
        end
      end

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter,
        retry_delay: fn _ -> 0 end
      ]

      assert {:ok, %Req.Response{status: 200}} = HumaansReq.request(client, request_opts)
      assert Agent.get(counter, & &1) == 3
    end

    test "stops retrying after max_retries", %{client: client} do
      {:ok, counter} = Agent.start_link(fn -> 0 end)

      adapter = fn request ->
        Agent.update(counter, &(&1 + 1))

        {request,
         %Req.Response{
           status: 429,
           body: %{"error" => "rate_limited"},
           headers: %{"retry-after" => ["0"]}
         }}
      end

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter,
        retry_delay: fn _ -> 0 end
      ]

      assert {:ok, %Req.Response{status: 429}} = HumaansReq.request(client, request_opts)
      assert Agent.get(counter, & &1) == 4
    end

    test "retry can be disabled via per-request opts", %{client: client} do
      {:ok, counter} = Agent.start_link(fn -> 0 end)

      adapter = fn request ->
        Agent.update(counter, &(&1 + 1))

        {request,
         %Req.Response{
           status: 429,
           body: %{"error" => "rate_limited"},
           headers: %{}
         }}
      end

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter,
        retry: false
      ]

      assert {:ok, %Req.Response{status: 429}} = HumaansReq.request(client, request_opts)
      assert Agent.get(counter, & &1) == 1
    end

    test "merges client.req_options into the Req config" do
      adapter = fn request ->
        send(self(), {:request_options, request.options})
        {request, %Req.Response{status: 200, body: %{"ok" => true}, headers: %{}}}
      end

      client = %Humaans{
        access_token: "tok",
        base_url: "https://app.humaans.io/api",
        http_client: HumaansReq,
        req_options: [connect_options: [timeout: 7_777], retry: false]
      }

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ]

      assert {:ok, _} = HumaansReq.request(client, request_opts)

      assert_received {:request_options, options}
      assert options[:connect_options] == [timeout: 7_777]
      assert options[:retry] == false
    end

    test "tolerates a struct whose :req_options is nil" do
      adapter = fn request ->
        {request, %Req.Response{status: 200, body: %{"ok" => true}, headers: %{}}}
      end

      client = %Humaans{
        access_token: "tok",
        base_url: "https://app.humaans.io/api",
        http_client: HumaansReq,
        req_options: nil
      }

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ]

      assert {:ok, _} = HumaansReq.request(client, request_opts)
    end

    test "does not allow req_options to override :base_url or :auth" do
      adapter = fn request ->
        send(self(), {:request, request})
        {request, %Req.Response{status: 200, body: %{"ok" => true}, headers: %{}}}
      end

      client = %Humaans{
        access_token: "real-token",
        base_url: "https://app.humaans.io/api",
        http_client: HumaansReq,
        req_options: [
          base_url: "https://evil.example.com",
          auth: {:bearer, "leaked-token"}
        ]
      }

      request_opts = [
        method: :get,
        url: "/people",
        headers: [{"Accept", "application/json"}],
        adapter: adapter
      ]

      assert {:ok, _} = HumaansReq.request(client, request_opts)

      assert_received {:request, request}
      assert request.options[:base_url] == "https://app.humaans.io/api"
      assert request.options[:auth] == {:bearer, "real-token"}
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
