defmodule Humaans.ErrorTest do
  use ExUnit.Case, async: true

  describe "Exception.message/1" do
    test "formats api_error with status and body" do
      error = %Humaans.Error{
        type: :api_error,
        status: 404,
        body: %{"error" => "not_found"}
      }

      assert Exception.message(error) =~
               "HTTP 404"

      assert Exception.message(error) =~
               "not_found"
    end

    test "formats api_error with api_message when present" do
      error = %Humaans.Error{
        type: :api_error,
        status: 422,
        api_message: "Validation failed",
        body: %{"message" => "Validation failed"}
      }

      assert Exception.message(error) == "Humaans API error: HTTP 422 - Validation failed"
    end

    test "formats network_error with reason" do
      error = %Humaans.Error{type: :network_error, reason: :econnrefused}

      assert Exception.message(error) =~ "econnrefused"
    end

    test "formats network_error with structured reason" do
      error = %Humaans.Error{type: :network_error, reason: %{reason: :timeout}}

      assert Exception.message(error) =~ "timeout"
    end
  end

  describe "from_api_response/2" do
    test "extracts code, name, message, and issues from structured body" do
      body = %{
        "id" => "req-1",
        "code" => "ValidationError",
        "name" => "BadRequest",
        "message" => "email is required",
        "issues" => [%{"path" => "email", "message" => "must be present"}]
      }

      error = Humaans.Error.from_api_response(422, body)

      assert error.type == :api_error
      assert error.status == 422
      assert error.code == "ValidationError"
      assert error.name == "BadRequest"
      assert error.api_message == "email is required"
      assert error.issues == [%{"path" => "email", "message" => "must be present"}]
      assert error.body == body
    end

    test "leaves structured fields nil when body lacks them" do
      body = %{"error" => "something"}
      error = Humaans.Error.from_api_response(500, body)

      assert error.type == :api_error
      assert error.status == 500
      assert error.code == nil
      assert error.name == nil
      assert error.api_message == nil
      assert error.issues == nil
      assert error.body == body
    end

    test "ignores non-string code/name/message values" do
      body = %{"code" => 42, "name" => nil, "message" => %{}}
      error = Humaans.Error.from_api_response(400, body)

      assert error.code == nil
      assert error.name == nil
      assert error.api_message == nil
    end

    test "ignores non-list issues values" do
      body = %{"issues" => "not a list"}
      error = Humaans.Error.from_api_response(400, body)
      assert error.issues == nil
    end

    test "handles non-map body" do
      error = Humaans.Error.from_api_response(502, "Bad Gateway")

      assert error.type == :api_error
      assert error.status == 502
      assert error.body == "Bad Gateway"
      assert error.code == nil
    end
  end

  describe "struct fields" do
    test "api_error has nil reason" do
      error = %Humaans.Error{type: :api_error, status: 500, body: %{}}
      assert is_nil(error.reason)
    end

    test "network_error has nil status and body" do
      error = %Humaans.Error{type: :network_error, reason: :timeout}
      assert is_nil(error.status)
      assert is_nil(error.body)
    end
  end

  describe "exception behaviour" do
    test "can be raised and rescued" do
      assert_raise Humaans.Error, fn ->
        raise Humaans.Error, type: :api_error, status: 500, body: %{}
      end
    end

    test "raised error is rescuable by type" do
      rescued =
        try do
          raise Humaans.Error, type: :network_error, reason: :timeout
        rescue
          e in Humaans.Error -> e
        end

      assert rescued.type == :network_error
      assert rescued.reason == :timeout
    end
  end

  describe "pattern matching" do
    test "matches on type and status" do
      error = %Humaans.Error{type: :api_error, status: 401, body: %{}}

      result =
        case {:error, error} do
          {:error, %Humaans.Error{type: :api_error, status: 401}} -> :unauthorized
          {:error, %Humaans.Error{type: :api_error, status: 404}} -> :not_found
          _ -> :other
        end

      assert result == :unauthorized
    end

    test "matches on network_error type" do
      error = %Humaans.Error{type: :network_error, reason: :econnrefused}

      result =
        case {:error, error} do
          {:error, %Humaans.Error{type: :network_error}} -> :network_failure
          _ -> :other
        end

      assert result == :network_failure
    end
  end
end
