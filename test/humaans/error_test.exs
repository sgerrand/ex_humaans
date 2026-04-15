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

    test "formats network_error with reason" do
      error = %Humaans.Error{type: :network_error, reason: :econnrefused}

      assert Exception.message(error) =~ "econnrefused"
    end

    test "formats network_error with structured reason" do
      error = %Humaans.Error{type: :network_error, reason: %{reason: :timeout}}

      assert Exception.message(error) =~ "timeout"
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
