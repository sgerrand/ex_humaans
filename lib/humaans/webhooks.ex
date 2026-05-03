defmodule Humaans.Webhooks do
  @moduledoc """
  Helpers for working with Humaans webhooks.

  Humaans signs webhook payloads with HMAC-SHA256 using your endpoint's
  signing secret. Verifying the signature on every delivery is required —
  treat any unverified payload as untrusted input.

  ## Verifying a delivery

      defp verify(conn, secret) do
        {:ok, raw_body, conn} = Plug.Conn.read_body(conn)
        signature = Plug.Conn.get_req_header(conn, "x-humaans-signature") |> List.first()

        case Humaans.Webhooks.verify_signature(raw_body, signature, secret) do
          :ok -> {:ok, conn, raw_body}
          {:error, _reason} = err -> err
        end
      end

  Always pass the **raw** request body to `verify_signature/3`. Re-serialised
  JSON will not match because byte-level differences (key ordering,
  whitespace) change the HMAC.
  """

  @doc """
  Verifies a webhook signature against the raw request body.

  Computes `HMAC-SHA256(secret, payload)` and compares it to `signature` in
  constant time.

  Accepts the signature as either a raw hex string (`"abc123..."`) or with a
  `sha256=` prefix (`"sha256=abc123..."`), so it works regardless of the
  exact convention used by the sender.

  ## Returns

  * `:ok` - Signature matches.
  * `{:error, :invalid_signature}` - Signature does not match the payload.
  * `{:error, :missing_signature}` - `signature` is `nil` or empty.
  * `{:error, :missing_secret}` - `secret` is `nil` or empty.

  ## Examples

      iex> body = ~s({"event":"person.updated"})
      iex> secret = "test-secret"
      iex> sig =
      ...>   :crypto.mac(:hmac, :sha256, secret, body)
      ...>   |> Base.encode16(case: :lower)
      iex> Humaans.Webhooks.verify_signature(body, sig, secret)
      :ok

      iex> Humaans.Webhooks.verify_signature("body", "deadbeef", "secret")
      {:error, :invalid_signature}

      iex> Humaans.Webhooks.verify_signature("body", nil, "secret")
      {:error, :missing_signature}
  """
  @spec verify_signature(payload :: binary(), signature :: String.t() | nil, secret :: String.t()) ::
          :ok | {:error, :invalid_signature | :missing_signature | :missing_secret}
  def verify_signature(_payload, nil, _secret), do: {:error, :missing_signature}
  def verify_signature(_payload, "", _secret), do: {:error, :missing_signature}
  def verify_signature(_payload, _signature, nil), do: {:error, :missing_secret}
  def verify_signature(_payload, _signature, ""), do: {:error, :missing_secret}

  def verify_signature(payload, signature, secret)
      when is_binary(payload) and is_binary(signature) and is_binary(secret) do
    expected = :crypto.mac(:hmac, :sha256, secret, payload) |> Base.encode16(case: :lower)
    provided = strip_prefix(signature) |> String.downcase()

    if secure_compare(expected, provided) do
      :ok
    else
      {:error, :invalid_signature}
    end
  end

  defp strip_prefix("sha256=" <> rest), do: rest
  defp strip_prefix(other), do: other

  # Constant-time string comparison. :crypto.hash_equals/2 is available since
  # OTP 25, but only accepts equal-length binaries; the length check has to
  # happen first (and discloses length, which is unavoidable).
  defp secure_compare(a, b) when byte_size(a) == byte_size(b) do
    :crypto.hash_equals(a, b)
  end

  defp secure_compare(_, _), do: false
end
