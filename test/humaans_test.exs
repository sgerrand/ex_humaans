defmodule HumaansTest do
  use ExUnit.Case

  doctest Humaans

  test "new/1" do
    client = Humaans.new(access_token: "some api key")

    assert Map.has_key?(client.req, :options)
    assert client.req.options.auth == {:bearer, "some api key"}
    assert client.req.options.base_url == "https://app.humaans.io/api"
  end
end
