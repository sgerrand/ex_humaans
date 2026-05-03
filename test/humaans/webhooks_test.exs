defmodule Humaans.WebhooksTest do
  use ExUnit.Case, async: true
  doctest Humaans.Webhooks

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
end
