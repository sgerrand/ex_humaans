defmodule Humaans.CaseConvertTest do
  use ExUnit.Case, async: true

  alias Humaans.CaseConvert

  describe "to_camel_case_keys/1 with maps" do
    test "converts snake_case atom keys to camelCase atoms" do
      assert CaseConvert.to_camel_case_keys(%{first_name: "Jane"}) == %{firstName: "Jane"}
    end

    test "converts snake_case string keys to camelCase strings" do
      assert CaseConvert.to_camel_case_keys(%{"first_name" => "Jane"}) == %{"firstName" => "Jane"}
    end

    test "preserves already-camelCase keys" do
      assert CaseConvert.to_camel_case_keys(%{firstName: "Jane"}) == %{firstName: "Jane"}
    end

    test "preserves single-word keys" do
      assert CaseConvert.to_camel_case_keys(%{email: "jane@example.com"}) == %{
               email: "jane@example.com"
             }
    end

    test "converts multiple underscored segments" do
      assert CaseConvert.to_camel_case_keys(%{employment_start_date: "2024-01-01"}) == %{
               employmentStartDate: "2024-01-01"
             }
    end

    test "leaves nested values untouched (only top-level keys are rewritten)" do
      assert CaseConvert.to_camel_case_keys(%{address: %{street_name: "Main"}}) == %{
               address: %{street_name: "Main"}
             }
    end

    test "returns empty map unchanged" do
      assert CaseConvert.to_camel_case_keys(%{}) == %{}
    end
  end

  describe "to_camel_case_keys/1 with keyword lists" do
    test "converts snake_case atom keys" do
      assert CaseConvert.to_camel_case_keys(first_name: "Jane", last_name: "Doe") ==
               [firstName: "Jane", lastName: "Doe"]
    end

    test "preserves order" do
      input = [b_field: 1, a_field: 2, c_field: 3]
      assert CaseConvert.to_camel_case_keys(input) == [bField: 1, aField: 2, cField: 3]
    end

    test "passes through non-tuple list elements" do
      assert CaseConvert.to_camel_case_keys([:foo, :bar]) == [:foo, :bar]
    end
  end

  describe "to_camel_case_keys/1 edge cases" do
    test "ignores structs" do
      input = %URI{scheme: "https", host: "example.com"}
      assert CaseConvert.to_camel_case_keys(input) == input
    end

    test "passes through other types unchanged" do
      assert CaseConvert.to_camel_case_keys(nil) == nil
      assert CaseConvert.to_camel_case_keys("string") == "string"
      assert CaseConvert.to_camel_case_keys(42) == 42
    end

    test "non-string/atom keys pass through" do
      assert CaseConvert.to_camel_case_keys(%{1 => "x"}) == %{1 => "x"}
    end

    test "preserves non-lowercase segments after underscore" do
      assert CaseConvert.to_camel_case_keys(%{foo_BAR: "x"}) == %{fooBAR: "x"}
    end

    test "handles consecutive underscores" do
      assert CaseConvert.to_camel_case_keys(%{foo__bar: "x"}) == %{fooBar: "x"}
    end
  end

  describe "Client integration" do
    setup do
      client = Humaans.new(access_token: "tok", http_client: Humaans.MockHTTPClient)
      Mox.verify_on_exit!(client)
      [client: client]
    end

    test "POST converts snake_case body keys to camelCase", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        body = Keyword.fetch!(opts, :body)
        assert body == %{firstName: "Jane", lastName: "Doe"}
        {:ok, %{status: 201, body: %{"id" => "abc", "firstName" => "Jane"}}}
      end)

      Humaans.People.create(client, %{first_name: "Jane", last_name: "Doe"})
    end

    test "PATCH converts snake_case body keys to camelCase", %{client: client} do
      Mox.expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        body = Keyword.fetch!(opts, :body)
        assert body == %{firstName: "Janet"}
        {:ok, %{status: 200, body: %{"id" => "abc", "firstName" => "Janet"}}}
      end)

      Humaans.People.update(client, "abc", %{first_name: "Janet"})
    end
  end
end
