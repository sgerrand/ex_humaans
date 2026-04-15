defmodule Humaans.Resources.TimestampsTest do
  use ExUnit.Case, async: true

  import Humaans.Resources.Timestamps

  describe "parse_date/2" do
    test "parses a valid ISO 8601 date string" do
      struct = %{birthday: "1989-07-28"}
      assert parse_date(struct, :birthday) == %{birthday: ~D[1989-07-28]}
    end

    test "returns struct unchanged when field is nil" do
      struct = %{birthday: nil}
      assert parse_date(struct, :birthday) == struct
    end

    test "returns struct unchanged when field is empty string" do
      struct = %{birthday: ""}
      assert parse_date(struct, :birthday) == struct
    end

    test "returns struct unchanged when field is already a Date" do
      struct = %{birthday: ~D[1989-07-28]}
      assert parse_date(struct, :birthday) == struct
    end

    test "returns struct unchanged when field is missing" do
      struct = %{name: "Kelsey"}
      assert parse_date(struct, :birthday) == struct
    end

    test "returns struct unchanged when value is an invalid date string" do
      struct = %{birthday: "not-a-date"}
      assert parse_date(struct, :birthday) == struct
    end

    test "returns struct unchanged when value is an invalid date format" do
      struct = %{birthday: "28-07-1989"}
      assert parse_date(struct, :birthday) == struct
    end

    test "parses date at the start of a year" do
      struct = %{employment_start_date: "2018-01-01"}

      assert parse_date(struct, :employment_start_date) == %{
               employment_start_date: ~D[2018-01-01]
             }
    end

    test "parses date at the end of a year" do
      struct = %{employment_end_date: "2023-12-31"}
      assert parse_date(struct, :employment_end_date) == %{employment_end_date: ~D[2023-12-31]}
    end

    test "does not affect other fields in the struct" do
      struct = %{name: "Kelsey", birthday: "1989-07-28"}
      result = parse_date(struct, :birthday)
      assert result.name == "Kelsey"
      assert result.birthday == ~D[1989-07-28]
    end
  end

  describe "parse_datetime/2" do
    test "parses a valid ISO 8601 UTC datetime string" do
      struct = %{created_at: "2021-03-22T10:40:43.951Z"}

      assert parse_datetime(struct, :created_at) == %{
               created_at: ~U[2021-03-22 10:40:43.951Z]
             }
    end

    test "parses a valid ISO 8601 datetime string with offset" do
      struct = %{created_at: "2021-03-22T11:40:43.951+01:00"}
      result = parse_datetime(struct, :created_at)
      assert %DateTime{} = result.created_at
      assert result.created_at.hour == 10
      assert result.created_at.minute == 40
    end

    test "returns struct unchanged when field is nil" do
      struct = %{created_at: nil}
      assert parse_datetime(struct, :created_at) == struct
    end

    test "returns struct unchanged when field is empty string" do
      struct = %{created_at: ""}
      assert parse_datetime(struct, :created_at) == struct
    end

    test "returns struct unchanged when field is already a DateTime" do
      struct = %{created_at: ~U[2021-03-22 10:40:43Z]}
      assert parse_datetime(struct, :created_at) == struct
    end

    test "returns struct unchanged when field is missing" do
      struct = %{name: "Kelsey"}
      assert parse_datetime(struct, :created_at) == struct
    end

    test "returns struct unchanged when value is an invalid datetime string" do
      struct = %{created_at: "not-a-datetime"}
      assert parse_datetime(struct, :created_at) == struct
    end

    test "returns struct unchanged when value is a date-only string" do
      struct = %{created_at: "2021-03-22"}
      assert parse_datetime(struct, :created_at) == struct
    end

    test "does not affect other fields in the struct" do
      struct = %{name: "Kelsey", created_at: "2021-03-22T10:40:43.951Z"}
      result = parse_datetime(struct, :created_at)
      assert result.name == "Kelsey"
      assert %DateTime{} = result.created_at
    end
  end
end
