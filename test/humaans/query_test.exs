defmodule Humaans.QueryTest do
  use ExUnit.Case, async: true

  alias Humaans.Query

  describe "operators" do
    test "eq emits the field as-is" do
      params = Query.new() |> Query.eq(:companyId, "abc") |> Query.to_params()
      assert params == [companyId: "abc"]
    end

    test "in_ encodes a $in suffix and preserves list value" do
      params = Query.new() |> Query.in_(:status, ["active", "onboarding"]) |> Query.to_params()
      assert params == [{:"status[$in]", ["active", "onboarding"]}]
    end

    test "nin encodes a $nin suffix" do
      params = Query.new() |> Query.nin(:status, ["archived"]) |> Query.to_params()
      assert params == [{:"status[$nin]", ["archived"]}]
    end

    test "gt/gte/lt/lte encode the matching operator" do
      params =
        Query.new()
        |> Query.gt(:createdAt, "2025-01-01")
        |> Query.gte(:updatedAt, "2025-02-01")
        |> Query.lt(:deletedAt, "2025-12-31")
        |> Query.lte(:effectiveDate, "2026-01-01")
        |> Query.to_params()

      assert params == [
               {:"createdAt[$gt]", "2025-01-01"},
               {:"updatedAt[$gte]", "2025-02-01"},
               {:"deletedAt[$lt]", "2025-12-31"},
               {:"effectiveDate[$lte]", "2026-01-01"}
             ]
    end

    test "accepts string field names" do
      params = Query.new() |> Query.gt("createdAt", "2025-01-01") |> Query.to_params()
      assert params == [{:"createdAt[$gt]", "2025-01-01"}]
    end

    test "preserves insertion order" do
      params =
        Query.new()
        |> Query.eq(:a, 1)
        |> Query.eq(:b, 2)
        |> Query.eq(:c, 3)
        |> Query.to_params()

      assert Keyword.keys(params) == [:a, :b, :c]
    end
  end

  describe "merge/2" do
    test "merges keyword list onto query" do
      params =
        Query.new()
        |> Query.in_(:status, ["active"])
        |> Query.merge("$limit": 50, "$skip": 0)
        |> Query.to_params()

      assert params == [
               {:"status[$in]", ["active"]},
               {:"$limit", 50},
               {:"$skip", 0}
             ]
    end

    test "merges another Query" do
      a = Query.new() |> Query.eq(:companyId, "abc")
      b = Query.new() |> Query.gt(:createdAt, "2025-01-01")

      params = a |> Query.merge(b) |> Query.to_params()

      assert params == [
               {:companyId, "abc"},
               {:"createdAt[$gt]", "2025-01-01"}
             ]
    end
  end
end
