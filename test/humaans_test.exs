defmodule HumaansTest do
  use ExUnit.Case, async: true

  doctest Humaans

  test "new/1" do
    client = Humaans.new(access_token: "some api key")

    assert Map.has_key?(client.req, :options)
    assert client.req.options.auth == {:bearer, "some api key"}
    assert client.req.options.base_url == "https://app.humaans.io/api"
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
