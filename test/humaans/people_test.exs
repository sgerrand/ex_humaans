defmodule Humaans.PeopleTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.People

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of people" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, path, _params ->
        assert client_param == client
        assert path == "/people"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "VMB1yzL5uL8VvNNCJc9rykJz",
                 "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
                 "firstName" => "Kelsey",
                 "middleName" => nil,
                 "lastName" => "Wicks",
                 "preferredName" => nil,
                 "email" => "kelsey@acme.com",
                 "locationId" => "FnAjNOIyLRsmZGRohZsHApiE",
                 "remoteCity" => nil,
                 "remoteRegionCode" => nil,
                 "remoteCountryCode" => nil,
                 "remoteTimezone" => nil,
                 "personalEmail" => "kwicks@example.com",
                 "phoneNumber" => "+4479460001",
                 "formattedPhoneNumber" => "+44 7946 0001",
                 "personalPhoneNumber" => nil,
                 "formattedPersonalPhoneNumber" => nil,
                 "gender" => "Female",
                 "birthday" => "1989-07-28",
                 "profilePhotoId" => "Hgi5auXaKsjn2MjuYo1PDk3W",
                 "profilePhoto" => %{
                   "id" => "Hgi5auXaKsjn2MjuYo1PDk3W",
                   "variants" => %{
                     "64" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@64.jpg",
                     "96" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@96.jpg",
                     "104" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@104.jpg",
                     "136" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@136.jpg",
                     "156" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@156.jpg",
                     "204" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@204.jpg",
                     "320" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@320.jpg",
                     "480" =>
                       "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@480.jpg"
                   }
                 },
                 "nationality" => "British",
                 "nationalities" => [
                   "British"
                 ],
                 "spokenLanguages" => [
                   "English"
                 ],
                 "dietaryPreference" => "Pescetarian",
                 "foodAllergies" => [
                   "Peanuts"
                 ],
                 "address" => "58 Stroude Road",
                 "city" => "Siddington",
                 "state" => nil,
                 "postcode" => "SK11 1EN",
                 "countryCode" => "GB",
                 "country" => "United Kingdom",
                 "bio" => "All about that filter coffee.",
                 "linkedIn" => nil,
                 "twitter" => nil,
                 "github" => nil,
                 "employmentStartDate" => "2018-03-10",
                 "firstWorkingDay" => "2018-03-10",
                 "employmentEndDate" => nil,
                 "lastWorkingDay" => "2018-03-10",
                 "probationEndDate" => nil,
                 "turnoverImpact" => nil,
                 "workingDays" => [
                   %{
                     "day" => "monday"
                   },
                   %{
                     "day" => "tuesday"
                   },
                   %{
                     "day" => "wednesday"
                   },
                   %{
                     "day" => "thursday"
                   },
                   %{
                     "day" => "friday"
                   }
                 ],
                 "publicHolidayCalendarId" => "ES-MD",
                 "leavingReason" => nil,
                 "leavingNote" => nil,
                 "leavingFileId" => nil,
                 "contractType" => "Full time",
                 "employeeId" => nil,
                 "taxId" => "QQ123456C",
                 "taxCode" => "123456C",
                 "teams" => [
                   %{
                     "name" => "Moonshot"
                   },
                   %{
                     "name" => "Growth Pod"
                   }
                 ],
                 "status" => "active",
                 "isVerified" => true,
                 "isWorkEmailHidden" => false,
                 "calendarFeedToken" => "bb6LCUqG4BAOZWKXQQB9a8H9",
                 "role" => "user",
                 "seenDocumentsAt" => "2020-02-21T17:09:29.290Z",
                 "source" => nil,
                 "sourceId" => nil,
                 "timezone" => "Europe/London",
                 "payrollProvider" => nil,
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, response} = Humaans.People.list(client)
      assert length(response) == 1
      assert hd(response).id == "VMB1yzL5uL8VvNNCJc9rykJz"
      assert hd(response).company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert hd(response).first_name == "Kelsey"
      assert hd(response).middle_name == nil
      assert hd(response).last_name == "Wicks"
      assert hd(response).preferred_name == nil
      assert hd(response).email == "kelsey@acme.com"
      assert hd(response).remote_city == nil
      assert hd(response).remote_region_code == nil
      assert hd(response).remote_country_code == nil
      assert hd(response).remote_timezone == nil
      assert hd(response).personal_email == "kwicks@example.com"
      assert hd(response).phone_number == "+4479460001"
      assert hd(response).formatted_phone_number == "+44 7946 0001"
      assert hd(response).personal_phone_number == nil
      assert hd(response).formatted_personal_phone_number == nil
      assert hd(response).gender == "Female"
      assert hd(response).birthday == "1989-07-28"
      assert hd(response).profile_photo_id == "Hgi5auXaKsjn2MjuYo1PDk3W"

      assert hd(response).profile_photo
             |> Map.keys()
             |> length == 2

      assert hd(response).profile_photo["id"] == "Hgi5auXaKsjn2MjuYo1PDk3W"

      assert hd(response).profile_photo["variants"]
             |> Map.keys()
             |> length == 8

      assert hd(response).profile_photo["variants"]["104"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@104.jpg"

      assert hd(response).profile_photo["variants"]["136"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@136.jpg"

      assert hd(response).profile_photo["variants"]["156"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@156.jpg"

      assert hd(response).profile_photo["variants"]["204"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@204.jpg"

      assert hd(response).profile_photo["variants"]["320"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@320.jpg"

      assert hd(response).profile_photo["variants"]["480"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@480.jpg"

      assert hd(response).profile_photo["variants"]["64"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@64.jpg"

      assert hd(response).profile_photo["variants"]["96"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@96.jpg"

      assert hd(response).created_at == "2020-01-28T08:44:42.000Z"
      assert hd(response).updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, _path, _params ->
        assert client_param == client
        {:ok, %{status: 404, body: %{"error" => "Person not found"}}}
      end)

      assert {:error, {404, %{"error" => "Person not found"}}} ==
               Humaans.People.list(client)
    end

    test "returns error when request fails" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, _path, _params ->
        assert client_param == client
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.People.list(client)
    end
  end

  describe "create/1" do
    test "creates a new person" do
      client = %{req: Req.new()}

      params = %{
        "firstName" => "Kelsey",
        "lastName" => "Wicks",
        "email" => "kelsey@acme.com",
        "locationId" => "FnAjNOIyLRsmZGRohZsHApiE",
        "jobRole" => %{
          "jobTitle" => "Software Engineer",
          "department" => "Engineering",
          "reportingTo" => "OfcRvv174ir3Y6mNA5bPXqeY"
        },
        "employmentStartDate" => "2018-03-10"
      }

      expect(Humaans.MockClient, :post, fn client_param, path, ^params ->
        assert client_param == client
        assert path == "/people"

        {:ok,
         %{
           status: 201,
           body:
             params
             |> Map.put("id", "new_id")
             |> Map.put("companyId", "T7uqPFK7am4lFTZm39AmNuay")
             |> Map.put("created_at", "2020-01-28T08:44:42.000Z")
             |> Map.put("updated_at", "2020-01-29T14:52:21.000Z")
         }}
      end)

      assert {:ok, response} = Humaans.People.create(client, params)
      assert response.id == "new_id"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.first_name == "Kelsey"
      assert response.middle_name == nil
      assert response.last_name == "Wicks"
      assert response.preferred_name == nil
      assert response.email == "kelsey@acme.com"
      assert response.remote_city == nil
      assert response.remote_region_code == nil
      assert response.remote_country_code == nil
      assert response.remote_timezone == nil
      assert response.personal_email == nil
      assert response.phone_number == nil
      assert response.formatted_phone_number == nil
      assert response.personal_phone_number == nil
      assert response.formatted_personal_phone_number == nil
      assert response.gender == nil
      assert response.birthday == nil
      assert response.profile_photo_id == nil
      assert response.profile_photo == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "retrieve/1" do
    test "retrieves a person" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :get, fn client_param, path ->
        assert client_param == client
        assert path == "/people/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "VMB1yzL5uL8VvNNCJc9rykJz",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "firstName" => "Kelsey",
             "middleName" => nil,
             "lastName" => "Wicks",
             "preferredName" => nil,
             "email" => "kelsey@acme.com",
             "locationId" => "FnAjNOIyLRsmZGRohZsHApiE",
             "remoteCity" => nil,
             "remoteRegionCode" => nil,
             "remoteCountryCode" => nil,
             "remoteTimezone" => nil,
             "personalEmail" => "kwicks@example.com",
             "phoneNumber" => "+4479460001",
             "formattedPhoneNumber" => "+44 7946 0001",
             "personalPhoneNumber" => nil,
             "formattedPersonalPhoneNumber" => nil,
             "gender" => "Female",
             "birthday" => "1989-07-28",
             "profilePhotoId" => "Hgi5auXaKsjn2MjuYo1PDk3W",
             "profilePhoto" => %{
               "id" => "Hgi5auXaKsjn2MjuYo1PDk3W",
               "variants" => %{
                 "64" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@64.jpg",
                 "96" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@96.jpg",
                 "104" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@104.jpg",
                 "136" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@136.jpg",
                 "156" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@156.jpg",
                 "204" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@204.jpg",
                 "320" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@320.jpg",
                 "480" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@480.jpg"
               }
             },
             "nationality" => "British",
             "nationalities" => [
               "British"
             ],
             "spokenLanguages" => [
               "English"
             ],
             "dietaryPreference" => "Pescetarian",
             "foodAllergies" => [
               "Peanuts"
             ],
             "address" => "58 Stroude Road",
             "city" => "Siddington",
             "state" => nil,
             "postcode" => "SK11 1EN",
             "countryCode" => "GB",
             "country" => "United Kingdom",
             "bio" => "All about that filter coffee.",
             "linkedIn" => nil,
             "twitter" => nil,
             "github" => nil,
             "employmentStartDate" => "2018-03-10",
             "firstWorkingDay" => "2018-03-10",
             "employmentEndDate" => nil,
             "lastWorkingDay" => "2018-03-10",
             "probationEndDate" => nil,
             "turnoverImpact" => nil,
             "workingDays" => [
               %{
                 "day" => "monday"
               },
               %{
                 "day" => "tuesday"
               },
               %{
                 "day" => "wednesday"
               },
               %{
                 "day" => "thursday"
               },
               %{
                 "day" => "friday"
               }
             ],
             "publicHolidayCalendarId" => "ES-MD",
             "leavingReason" => nil,
             "leavingNote" => nil,
             "leavingFileId" => nil,
             "contractType" => "Full time",
             "employeeId" => nil,
             "taxId" => "QQ123456C",
             "taxCode" => "123456C",
             "teams" => [
               %{
                 "name" => "Moonshot"
               },
               %{
                 "name" => "Growth Pod"
               }
             ],
             "status" => "active",
             "isVerified" => true,
             "isWorkEmailHidden" => false,
             "calendarFeedToken" => "bb6LCUqG4BAOZWKXQQB9a8H9",
             "role" => "user",
             "seenDocumentsAt" => "2020-02-21T17:09:29.290Z",
             "source" => nil,
             "sourceId" => nil,
             "timezone" => "Europe/London",
             "payrollProvider" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.People.retrieve(client, "Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "VMB1yzL5uL8VvNNCJc9rykJz"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.first_name == "Kelsey"
      assert response.middle_name == nil
      assert response.last_name == "Wicks"
      assert response.preferred_name == nil
      assert response.email == "kelsey@acme.com"
      assert response.remote_city == nil
      assert response.remote_region_code == nil
      assert response.remote_country_code == nil
      assert response.remote_timezone == nil
      assert response.personal_email == "kwicks@example.com"
      assert response.phone_number == "+4479460001"
      assert response.formatted_phone_number == "+44 7946 0001"
      assert response.personal_phone_number == nil
      assert response.formatted_personal_phone_number == nil
      assert response.gender == "Female"
      assert response.birthday == "1989-07-28"
      assert response.profile_photo_id == "Hgi5auXaKsjn2MjuYo1PDk3W"

      assert response.profile_photo
             |> Map.keys()
             |> length == 2

      assert response.profile_photo["id"] == "Hgi5auXaKsjn2MjuYo1PDk3W"

      assert response.profile_photo["variants"]
             |> Map.keys()
             |> length == 8

      assert response.profile_photo["variants"]["104"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@104.jpg"

      assert response.profile_photo["variants"]["136"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@136.jpg"

      assert response.profile_photo["variants"]["156"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@156.jpg"

      assert response.profile_photo["variants"]["204"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@204.jpg"

      assert response.profile_photo["variants"]["320"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@320.jpg"

      assert response.profile_photo["variants"]["480"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@480.jpg"

      assert response.profile_photo["variants"]["64"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@64.jpg"

      assert response.profile_photo["variants"]["96"] ==
               "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@96.jpg"

      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a person" do
      client = %{req: Req.new()}
      params = %{"middleName" => "some middle name"}

      expect(Humaans.MockClient, :patch, fn client_param, path, ^params ->
        assert client_param == client
        assert path == "/people/VMB1yzL5uL8VvNNCJc9rykJz"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "VMB1yzL5uL8VvNNCJc9rykJz",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "firstName" => "Kelsey",
             "middleName" => "some middle name",
             "lastName" => "Wicks",
             "preferredName" => nil,
             "email" => "kelsey@acme.com",
             "locationId" => "FnAjNOIyLRsmZGRohZsHApiE",
             "remoteCity" => nil,
             "remoteRegionCode" => nil,
             "remoteCountryCode" => nil,
             "remoteTimezone" => nil,
             "personalEmail" => "kwicks@example.com",
             "phoneNumber" => "+4479460001",
             "formattedPhoneNumber" => "+44 7946 0001",
             "personalPhoneNumber" => nil,
             "formattedPersonalPhoneNumber" => nil,
             "gender" => "Female",
             "birthday" => "1989-07-28",
             "profilePhotoId" => "Hgi5auXaKsjn2MjuYo1PDk3W",
             "profilePhoto" => %{
               "id" => "Hgi5auXaKsjn2MjuYo1PDk3W",
               "variants" => %{
                 "64" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@64.jpg",
                 "96" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@96.jpg",
                 "104" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@104.jpg",
                 "136" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@136.jpg",
                 "156" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@156.jpg",
                 "204" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@204.jpg",
                 "320" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@320.jpg",
                 "480" =>
                   "https://storage.googleapis.com/humaans-public-prd/Hgi5auXaKsjn2MjuYo1PDk3W@480.jpg"
               }
             },
             "nationality" => "British",
             "nationalities" => [
               "British"
             ],
             "spokenLanguages" => [
               "English"
             ],
             "dietaryPreference" => "Pescetarian",
             "foodAllergies" => [
               "Peanuts"
             ],
             "address" => "58 Stroude Road",
             "city" => "Siddington",
             "state" => nil,
             "postcode" => "SK11 1EN",
             "countryCode" => "GB",
             "country" => "United Kingdom",
             "bio" => "All about that filter coffee.",
             "linkedIn" => nil,
             "twitter" => nil,
             "github" => nil,
             "employmentStartDate" => "2018-03-10",
             "firstWorkingDay" => "2018-03-10",
             "employmentEndDate" => nil,
             "lastWorkingDay" => "2018-03-10",
             "probationEndDate" => nil,
             "turnoverImpact" => nil,
             "workingDays" => [
               %{
                 "day" => "monday"
               },
               %{
                 "day" => "tuesday"
               },
               %{
                 "day" => "wednesday"
               },
               %{
                 "day" => "thursday"
               },
               %{
                 "day" => "friday"
               }
             ],
             "publicHolidayCalendarId" => "ES-MD",
             "leavingReason" => nil,
             "leavingNote" => nil,
             "leavingFileId" => nil,
             "contractType" => "Full time",
             "employeeId" => nil,
             "taxId" => "QQ123456C",
             "taxCode" => "123456C",
             "teams" => [
               %{
                 "name" => "Moonshot"
               },
               %{
                 "name" => "Growth Pod"
               }
             ],
             "status" => "active",
             "isVerified" => true,
             "isWorkEmailHidden" => false,
             "calendarFeedToken" => "bb6LCUqG4BAOZWKXQQB9a8H9",
             "role" => "user",
             "seenDocumentsAt" => "2020-02-21T17:09:29.290Z",
             "source" => nil,
             "sourceId" => nil,
             "timezone" => "Europe/London",
             "payrollProvider" => nil,
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.People.update(client, "VMB1yzL5uL8VvNNCJc9rykJz", params)
      assert response.id == "VMB1yzL5uL8VvNNCJc9rykJz"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.first_name == "Kelsey"
      assert response.middle_name == "some middle name"
      assert response.last_name == "Wicks"
      assert response.preferred_name == nil
      assert response.preferred_name == nil
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a person" do
      client = %{req: Req.new()}

      expect(Humaans.MockClient, :delete, fn client_param, path ->
        assert client_param == client
        assert path == "/people/Ivl8mvdLO8ux7T1h1DjGtClc"

        {:ok, %{status: 200, body: %{"id" => "Ivl8mvdLO8ux7T1h1DjGtClc", "deleted" => true}}}
      end)

      assert {:ok, response} = Humaans.People.delete(client, "Ivl8mvdLO8ux7T1h1DjGtClc")
      assert response.id == "Ivl8mvdLO8ux7T1h1DjGtClc"
      assert response.deleted == true
    end
  end
end
