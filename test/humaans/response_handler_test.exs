defmodule Humaans.ResponseHandlerTest do
  use ExUnit.Case, async: true

  alias Humaans.ResponseHandler

  # Mock resource module for testing
  defmodule MockResource do
    defstruct [:id, :name]

    def new(data) do
      %__MODULE__{
        id: data["id"],
        name: data["name"]
      }
    end
  end

  describe "handle_list_response/2" do
    test "correctly handles successful list response" do
      response = {:ok, %{status: 200, body: %{"data" => [%{"id" => "123", "name" => "Jane"}]}}}

      assert {:ok, [%MockResource{id: "123", name: "Jane"}]} =
               ResponseHandler.handle_list_response(response, MockResource)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 422, body: %{"error" => "validation_failed"}}}

      assert {:error, {422, %{"error" => "validation_failed"}}} =
               ResponseHandler.handle_list_response(response, MockResource)
    end

    test "passes through connection errors" do
      response = {:error, %{reason: :timeout}}

      assert {:error, %{reason: :timeout}} =
               ResponseHandler.handle_list_response(response, MockResource)
    end
  end

  describe "handle_resource_response/2" do
    test "correctly handles successful single resource response" do
      response = {:ok, %{status: 200, body: %{"id" => "123", "name" => "Jane"}}}

      assert {:ok, %MockResource{id: "123", name: "Jane"}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 404, body: %{"error" => "not_found"}}}

      assert {:error, {404, %{"error" => "not_found"}}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "passes through connection errors" do
      response = {:error, %{reason: :nxdomain}}

      assert {:error, %{reason: :nxdomain}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end
  end

  describe "handle_delete_response/1" do
    test "correctly handles successful delete response" do
      response = {:ok, %{status: 200, body: %{"deleted" => true, "id" => "123"}}}

      assert {:ok, %{deleted: true, id: "123"}} =
               ResponseHandler.handle_delete_response(response)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 403, body: %{"error" => "forbidden"}}}

      assert {:error, {403, %{"error" => "forbidden"}}} =
               ResponseHandler.handle_delete_response(response)
    end

    test "passes through connection errors" do
      response = {:error, %{reason: :econnrefused}}

      assert {:error, %{reason: :econnrefused}} =
               ResponseHandler.handle_delete_response(response)
    end
  end

  describe "handle_response/2" do
    test "correctly handles list data response" do
      response = {:ok, %{status: 200, body: %{"data" => [%{"id" => "123"}]}}}

      assert {:ok, "processed"} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "correctly handles single item response" do
      response = {:ok, %{status: 201, body: %{"id" => "123"}}}

      assert {:ok, "processed"} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 500, body: %{"error" => "server_error"}}}

      assert {:error, {500, %{"error" => "server_error"}}} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "passes through connection errors" do
      response = {:error, "connection_error"}

      assert {:error, "connection_error"} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end
  end
end
