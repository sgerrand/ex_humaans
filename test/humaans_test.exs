defmodule HumaansTest do
  use ExUnit.Case

  doctest Humaans

  test "new/1" do
    client = Humaans.new("some api key")

    assert Map.has_key?(client, :options)
    assert client.options.auth == {:bearer, "some api key"}
    assert client.options.base_url == "https://app.humaans.io/api"
  end
end
