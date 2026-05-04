defmodule Humaans.CaseConvertTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  alias Humaans.CaseConvert

  setup :verify_on_exit!

  describe "to_camel_case_keys/1 with maps" do
    test "converts snake_case atom keys to camelCase string keys" do
      assert CaseConvert.to_camel_case_keys(%{first_name: "Jane"}) == %{"firstName" => "Jane"}
    end

    test "converts snake_case string keys to camelCase string keys" do
      assert CaseConvert.to_camel_case_keys(%{"first_name" => "Jane"}) == %{"firstName" => "Jane"}
    end

    test "preserves already-camelCase keys (atoms become strings)" do
      assert CaseConvert.to_camel_case_keys(%{firstName: "Jane"}) == %{"firstName" => "Jane"}
    end

    test "preserves single-word keys" do
      assert CaseConvert.to_camel_case_keys(%{email: "jane@example.com"}) == %{
               "email" => "jane@example.com"
             }
    end

    test "converts multiple underscored segments" do
      assert CaseConvert.to_camel_case_keys(%{employment_start_date: "2024-01-01"}) == %{
               "employmentStartDate" => "2024-01-01"
             }
    end

    test "leaves nested values untouched (only top-level keys are rewritten)" do
      assert CaseConvert.to_camel_case_keys(%{address: %{street_name: "Main"}}) == %{
               "address" => %{street_name: "Main"}
             }
    end

    test "returns empty map unchanged" do
      assert CaseConvert.to_camel_case_keys(%{}) == %{}
    end

    test "raises when two input keys normalize to the same camelCase key" do
      assert_raise ArgumentError, ~r/normalize to "firstName"/, fn ->
        CaseConvert.to_camel_case_keys(%{first_name: 1, firstName: 2})
      end
    end

    test "raises on string/atom snake/camel collision" do
      assert_raise ArgumentError, ~r/normalize to "firstName"/, fn ->
        CaseConvert.to_camel_case_keys(%{"first_name" => 1, "firstName" => 2})
      end
    end
  end

  describe "to_camel_case_keys/1 with keyword lists" do
    test "converts snake_case atom keys to a string-keyed map" do
      assert CaseConvert.to_camel_case_keys(first_name: "Jane", last_name: "Doe") ==
               %{"firstName" => "Jane", "lastName" => "Doe"}
    end

    test "passes through non-keyword lists unchanged" do
      assert CaseConvert.to_camel_case_keys([:foo, :bar]) == [:foo, :bar]
    end

    test "passes through empty list unchanged" do
      assert CaseConvert.to_camel_case_keys([]) == []
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
      assert CaseConvert.to_camel_case_keys(%{foo_BAR: "x"}) == %{"fooBAR" => "x"}
    end

    test "handles consecutive underscores" do
      assert CaseConvert.to_camel_case_keys(%{foo__bar: "x"}) == %{"fooBar" => "x"}
    end

    test "does not create new atoms at runtime" do
      key = "ex_humaans_case_convert_#{System.unique_integer([:positive])}"

      refute_existing_atom("#{key}_field")
      refute_existing_atom(camel_of("#{key}_field"))

      _ = CaseConvert.to_camel_case_keys(%{"#{key}_field" => 1})

      refute_existing_atom(camel_of("#{key}_field"))
    end
  end

  describe "Client integration" do
    setup do
      [client: Humaans.new(access_token: "tok", http_client: Humaans.MockHTTPClient)]
    end

    test "POST converts snake_case body keys to camelCase", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        body = Keyword.fetch!(opts, :body)
        assert body == %{"firstName" => "Jane", "lastName" => "Doe"}
        {:ok, %{status: 201, body: %{"id" => "abc", "firstName" => "Jane"}}}
      end)

      Humaans.People.create(client, %{first_name: "Jane", last_name: "Doe"})
    end

    test "PATCH converts snake_case body keys to camelCase", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        body = Keyword.fetch!(opts, :body)
        assert body == %{"firstName" => "Janet"}
        {:ok, %{status: 200, body: %{"id" => "abc", "firstName" => "Janet"}}}
      end)

      Humaans.People.update(client, "abc", %{first_name: "Janet"})
    end
  end

  defp camel_of(snake) do
    [head | tail] = String.split(snake, "_")
    head <> Enum.map_join(tail, "", &String.capitalize/1)
  end

  defp refute_existing_atom(name) do
    assert_raise ArgumentError, fn -> String.to_existing_atom(name) end
  end
end
