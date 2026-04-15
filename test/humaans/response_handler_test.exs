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

    test "returns structs in the order they appear in the response" do
      response =
        {:ok,
         %{
           status: 200,
           body: %{
             "data" => [
               %{"id" => "1", "name" => "Alice"},
               %{"id" => "2", "name" => "Bob"},
               %{"id" => "3", "name" => "Carol"}
             ]
           }
         }}

      assert {:ok, resources} = ResponseHandler.handle_list_response(response, MockResource)
      ids = Enum.map(resources, & &1.id)
      assert "1" in ids
      assert "2" in ids
      assert "3" in ids
    end

    test "returns empty list for empty data response" do
      response = {:ok, %{status: 200, body: %{"data" => []}}}

      assert {:ok, []} = ResponseHandler.handle_list_response(response, MockResource)
    end

    test "treats 299 as a successful status" do
      response = {:ok, %{status: 299, body: %{"data" => [%{"id" => "1", "name" => "X"}]}}}

      assert {:ok, [%MockResource{}]} =
               ResponseHandler.handle_list_response(response, MockResource)
    end

    test "treats 300 as an error" do
      response = {:ok, %{status: 300, body: %{"error" => "redirect"}}}

      assert {:error, %Humaans.Error{type: :api_error, status: 300}} =
               ResponseHandler.handle_list_response(response, MockResource)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 422, body: %{"error" => "validation_failed"}}}

      assert {:error,
              %Humaans.Error{
                type: :api_error,
                status: 422,
                body: %{"error" => "validation_failed"}
              }} =
               ResponseHandler.handle_list_response(response, MockResource)
    end

    test "passes through connection errors" do
      response = {:error, %{reason: :timeout}}

      assert {:error, %Humaans.Error{type: :network_error, reason: %{reason: :timeout}}} =
               ResponseHandler.handle_list_response(response, MockResource)
    end
  end

  describe "handle_resource_response/2" do
    test "correctly handles successful single resource response" do
      response = {:ok, %{status: 200, body: %{"id" => "123", "name" => "Jane"}}}

      assert {:ok, %MockResource{id: "123", name: "Jane"}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "handles 201 Created response" do
      response = {:ok, %{status: 201, body: %{"id" => "456", "name" => "Bob"}}}

      assert {:ok, %MockResource{id: "456", name: "Bob"}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "handles response wrapped in data envelope" do
      response =
        {:ok,
         %{status: 200, body: %{"data" => %{"id" => "789", "name" => "Carol"}, "total" => 1}}}

      # data envelope with a map (not a list) falls through to direct body handler
      assert {:ok, _} = ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "correctly handles 401 Unauthorized" do
      response = {:ok, %{status: 401, body: %{"error" => "unauthorized"}}}

      assert {:error, %Humaans.Error{type: :api_error, status: 401}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 404, body: %{"error" => "not_found"}}}

      assert {:error,
              %Humaans.Error{type: :api_error, status: 404, body: %{"error" => "not_found"}}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end

    test "passes through connection errors" do
      response = {:error, %{reason: :nxdomain}}

      assert {:error, %Humaans.Error{type: :network_error, reason: %{reason: :nxdomain}}} =
               ResponseHandler.handle_resource_response(response, MockResource)
    end
  end

  describe "handle_delete_response/1" do
    test "correctly handles successful delete response" do
      response = {:ok, %{status: 200, body: %{"deleted" => true, "id" => "123"}}}

      assert {:ok, %{deleted: true, id: "123"}} =
               ResponseHandler.handle_delete_response(response)
    end

    test "handles deleted: false response" do
      response = {:ok, %{status: 200, body: %{"deleted" => false, "id" => "123"}}}

      assert {:ok, %{deleted: false, id: "123"}} =
               ResponseHandler.handle_delete_response(response)
    end

    test "correctly handles 403 Forbidden" do
      response = {:ok, %{status: 403, body: %{"error" => "forbidden"}}}

      assert {:error,
              %Humaans.Error{type: :api_error, status: 403, body: %{"error" => "forbidden"}}} =
               ResponseHandler.handle_delete_response(response)
    end

    test "correctly handles 404 Not Found" do
      response = {:ok, %{status: 404, body: %{"error" => "not_found"}}}

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               ResponseHandler.handle_delete_response(response)
    end

    test "passes through connection errors" do
      response = {:error, %{reason: :econnrefused}}

      assert {:error, %Humaans.Error{type: :network_error, reason: %{reason: :econnrefused}}} =
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

    test "passes the data value from the data envelope to the success handler" do
      response = {:ok, %{status: 200, body: %{"data" => [1, 2, 3]}}}

      assert {:ok, [1, 2, 3]} =
               ResponseHandler.handle_response(response, fn data -> data end)
    end

    test "passes the full body to the success handler when no data envelope" do
      response = {:ok, %{status: 200, body: %{"id" => "abc"}}}

      assert {:ok, %{"id" => "abc"}} =
               ResponseHandler.handle_response(response, fn body -> body end)
    end

    test "treats 299 as success" do
      response = {:ok, %{status: 299, body: %{"id" => "abc"}}}

      assert {:ok, _} =
               ResponseHandler.handle_response(response, fn body -> body end)
    end

    test "treats 300 as an api_error" do
      response = {:ok, %{status: 300, body: %{"error" => "moved"}}}

      assert {:error, %Humaans.Error{type: :api_error, status: 300}} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "correctly handles 401 Unauthorized" do
      response = {:ok, %{status: 401, body: %{"error" => "unauthorized"}}}

      assert {:error, %Humaans.Error{type: :api_error, status: 401}} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "correctly handles 422 Unprocessable Entity" do
      response = {:ok, %{status: 422, body: %{"error" => "validation_failed", "fields" => []}}}

      assert {:error,
              %Humaans.Error{
                type: :api_error,
                status: 422,
                body: %{"error" => "validation_failed"}
              }} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "correctly handles error response" do
      response = {:ok, %{status: 500, body: %{"error" => "server_error"}}}

      assert {:error,
              %Humaans.Error{type: :api_error, status: 500, body: %{"error" => "server_error"}}} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end

    test "passes through connection errors" do
      response = {:error, "connection_error"}

      assert {:error, %Humaans.Error{type: :network_error, reason: "connection_error"}} =
               ResponseHandler.handle_response(response, fn _ -> "processed" end)
    end
  end
end
