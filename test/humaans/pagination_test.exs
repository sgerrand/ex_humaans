defmodule Humaans.PaginationTest do
  use ExUnit.Case, async: false

  @person_fixture %{
    "id" => "IL3vneCYhIx0xrR6um2sy2nW",
    "companyId" => "Gu6LHHK3S2lBNiRKLNbEmCDM",
    "firstName" => "Kelsey",
    "lastName" => "Wicks",
    "email" => "kelsey@acme.com"
  }

  setup do
    client = Humaans.new(access_token: "test-token", http_client: Humaans.MockHTTPClient)
    {:ok, client: client}
  end

  describe "page/4" do
    test "fetches page 1 with skip=0", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 10, "$skip": 0]
        {:ok, %{status: 200, body: %{"data" => [@person_fixture]}}}
      end)

      assert {:ok, result} =
               Humaans.Pagination.page(client, &Humaans.People.list/2, 1, page_size: 10)

      assert result.page == 1
      assert result.page_size == 10
      assert length(result.data) == 1
    end

    test "fetches page 2 with correct skip offset", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 10, "$skip": 10]
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      assert {:ok, result} =
               Humaans.Pagination.page(client, &Humaans.People.list/2, 2, page_size: 10)

      assert result.page == 2
      assert result.data == []
    end

    test "uses default page size when not specified", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 100, "$skip": 0]
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      assert {:ok, result} = Humaans.Pagination.page(client, &Humaans.People.list/2, 1)
      assert result.page_size == 100
    end

    test "passes extra options as query params", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == [personId: "abc", "$limit": 10, "$skip": 0]
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      assert {:ok, _result} =
               Humaans.Pagination.page(client, &Humaans.People.list/2, 1,
                 page_size: 10,
                 personId: "abc"
               )
    end

    test "returns error on API error", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 401, body: %{"error" => "unauthorized"}}}
      end)

      assert {:error, _} = Humaans.Pagination.page(client, &Humaans.People.list/2, 1)
    end
  end

  describe "stream/3" do
    test "yields all items across multiple pages", %{client: client} do
      # Page 1: full page of 2
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 2, "$skip": 0]
        {:ok, %{status: 200, body: %{"data" => [@person_fixture, @person_fixture]}}}
      end)

      # Page 2: partial page (last page)
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 2, "$skip": 2]
        {:ok, %{status: 200, body: %{"data" => [@person_fixture]}}}
      end)

      results =
        client
        |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 2)
        |> Enum.to_list()

      assert length(results) == 3
    end

    test "stops at an empty page", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      results =
        client
        |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 10)
        |> Enum.to_list()

      assert results == []
    end

    test "stops after a full page followed by an empty page", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 1, "$skip": 0]
        {:ok, %{status: 200, body: %{"data" => [@person_fixture]}}}
      end)

      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 1, "$skip": 1]
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      results =
        client
        |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 1)
        |> Enum.to_list()

      assert length(results) == 1
    end

    test "halts silently on API error", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 401, body: %{"error" => "unauthorized"}}}
      end)

      results =
        client
        |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 10)
        |> Enum.to_list()

      assert results == []
    end

    test "uses default page size when not specified", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert opts[:params] == ["$limit": 100, "$skip": 0]
        {:ok, %{status: 200, body: %{"data" => []}}}
      end)

      results =
        client
        |> Humaans.Pagination.stream(&Humaans.People.list/2)
        |> Enum.to_list()

      assert results == []
    end

    test "is lazy and only fetches pages on demand", %{client: client} do
      # Only one request should be made because we only take 1 item
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 200, body: %{"data" => [@person_fixture, @person_fixture]}}}
      end)

      result =
        client
        |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 2)
        |> Enum.take(1)

      assert length(result) == 1
    end
  end
end
