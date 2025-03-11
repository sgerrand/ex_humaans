defmodule HumaansTest do
  use ExUnit.Case, async: true

  doctest Humaans

  describe "new/1" do
    test "with default options" do
      client = Humaans.new(access_token: "some api key")

      assert client.access_token == "some api key"
      assert client.base_url == "https://app.humaans.io/api"
      assert client.http_client == Humaans.HTTPClient.Req
    end

    test "base URL is configurable" do
      client = Humaans.new(access_token: "some api key", base_url: "http://some-base.url/path")

      assert client.access_token == "some api key"
      assert client.base_url == "http://some-base.url/path"
      assert client.http_client == Humaans.HTTPClient.Req
    end

    test "HTTP client is configurable" do
      client = Humaans.new(access_token: "some api key", http_client: Humaans.MockHTTPClient)

      assert client.access_token == "some api key"
      assert client.base_url == "https://app.humaans.io/api"
      assert client.http_client == Humaans.MockHTTPClient
    end
  end

  describe "struct" do
    test "all keys are required" do
      assert %Humaans{access_token: nil, base_url: nil, http_client: nil} ==
               struct!(Humaans, access_token: nil, base_url: nil, http_client: nil)
    end

    test "access_token is required" do
      assert_raise ArgumentError,
                   "the following keys must also be given when building struct Humaans: [:access_token]",
                   fn ->
                     struct!(Humaans, base_url: nil, http_client: nil)
                   end
    end

    test "base_url is required" do
      assert_raise ArgumentError,
                   "the following keys must also be given when building struct Humaans: [:base_url]",
                   fn ->
                     struct!(Humaans, access_token: nil, http_client: nil)
                   end
    end

    test "http_client is required" do
      assert_raise ArgumentError,
                   "the following keys must also be given when building struct Humaans: [:http_client]",
                   fn ->
                     struct!(Humaans, access_token: nil, base_url: nil)
                   end
    end
  end

  test "people/0 returns the People module" do
    assert Humaans.people() == Humaans.People
  end

  test "bank_accounts/0 returns the BankAccounts module" do
    assert Humaans.bank_accounts() == Humaans.BankAccounts
  end

  test "companies/0 returns the Companies module" do
    assert Humaans.companies() == Humaans.Companies
  end

  test "compensation_types/0 returns the CompensationTypes module" do
    assert Humaans.compensation_types() == Humaans.CompensationTypes
  end

  test "compensations/0 returns the Compensations module" do
    assert Humaans.compensations() == Humaans.Compensations
  end

  test "timesheet_entries/0 returns the TimesheetEntries module" do
    assert Humaans.timesheet_entries() == Humaans.TimesheetEntries
  end

  test "timesheet_submissions/0 returns the TimesheetSubmissions module" do
    assert Humaans.timesheet_submissions() == Humaans.TimesheetSubmissions
  end
end
