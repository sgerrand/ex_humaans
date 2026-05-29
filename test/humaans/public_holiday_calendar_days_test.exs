defmodule Humaans.PublicHolidayCalendarDaysTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  doctest Humaans.PublicHolidayCalendarDays

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "some access token", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "list/1" do
    test "returns a list of public holiday calendar days", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/public-holiday-calendar-days"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "phcd_abc",
                 "publicHolidayCalendarId" => "cal_abc",
                 "publicHolidayId" => "ph_abc",
                 "createdAt" => "2025-01-01T08:44:42.000Z",
                 "updatedAt" => "2025-01-01T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, [response]} = Humaans.PublicHolidayCalendarDays.list(client)
      assert response.id == "phcd_abc"
      assert response.public_holiday_calendar_id == "cal_abc"
      assert response.public_holiday_id == "ph_abc"
    end

    test "returns error when resource is not found", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Not found"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 404}} =
               Humaans.PublicHolidayCalendarDays.list(client)
    end

    test "returns error when request fails", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, _opts ->
        assert client_param == client
        {:error, "boom"}
      end)

      assert {:error, %Humaans.Error{type: :network_error, reason: "boom"}} =
               Humaans.PublicHolidayCalendarDays.list(client)
    end
  end

  describe "create/2" do
    test "creates a public holiday calendar day", %{client: client} do
      params = %{"publicHolidayCalendarId" => "cal_abc", "publicHolidayId" => "ph_abc"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :post

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/public-holiday-calendar-days"

        {:ok, %{status: 201, body: Map.put(params, "id", "phcd_new")}}
      end)

      assert {:ok, response} = Humaans.PublicHolidayCalendarDays.create(client, params)
      assert response.id == "phcd_new"
    end
  end

  describe "retrieve/2" do
    test "retrieves a public holiday calendar day", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :method) == :get

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/public-holiday-calendar-days/phcd_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "phcd_abc",
             "publicHolidayCalendarId" => "cal_abc",
             "publicHolidayId" => "ph_abc",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-01T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.PublicHolidayCalendarDays.retrieve(client, "phcd_abc")
      assert response.public_holiday_id == "ph_abc"
    end
  end

  describe "update/3" do
    test "updates a public holiday calendar day", %{client: client} do
      params = %{"publicHolidayId" => "ph_def"}

      expect(Humaans.MockHTTPClient, :request, fn client_param, opts ->
        assert client_param == client
        assert Keyword.fetch!(opts, :body) == params
        assert Keyword.fetch!(opts, :method) == :patch

        assert Keyword.fetch!(opts, :url) ==
                 "https://app.humaans.io/api/public-holiday-calendar-days/phcd_abc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "phcd_abc",
             "publicHolidayCalendarId" => "cal_abc",
             "publicHolidayId" => "ph_def",
             "createdAt" => "2025-01-01T08:44:42.000Z",
             "updatedAt" => "2025-01-02T08:44:42.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.PublicHolidayCalendarDays.update(client, "phcd_abc", params)

      assert response.public_holiday_id == "ph_def"
    end
  end

  test "delete/2 is not exported" do
    refute function_exported?(Humaans.PublicHolidayCalendarDays, :delete, 2)
  end
end
