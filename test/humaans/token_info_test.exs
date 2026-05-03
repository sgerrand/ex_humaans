defmodule Humaans.TokenInfoTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "tok", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "get/1" do
    test "fetches /token-info and returns the body", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/token-info"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "tok_abc",
             "personId" => "person_xyz",
             "label" => "Integration token",
             "scopes" => ["private:read", "private:write"]
           }
         }}
      end)

      assert {:ok, info} = Humaans.TokenInfo.get(client)
      assert info["id"] == "tok_abc"
      assert info["personId"] == "person_xyz"
      assert info["scopes"] == ["private:read", "private:write"]
    end

    test "surfaces 401 as a Humaans.Error", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 401, body: %{"message" => "unauthorized"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 401}} =
               Humaans.TokenInfo.get(client)
    end
  end
end
