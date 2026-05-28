defmodule Humaans.MeTest do
  use ExUnit.Case, async: true

  import Mox, only: [expect: 3, verify_on_exit!: 1]

  setup :verify_on_exit!

  setup_all do
    client = Humaans.new(access_token: "tok", http_client: Humaans.MockHTTPClient)
    [client: client]
  end

  describe "get/1" do
    test "fetches /me and returns a Person struct", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, opts ->
        assert Keyword.fetch!(opts, :method) == :get
        assert Keyword.fetch!(opts, :url) == "https://app.humaans.io/api/me"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "person_abc",
             "companyId" => "company_xyz",
             "firstName" => "Jane",
             "lastName" => "Doe",
             "email" => "jane@example.com"
           }
         }}
      end)

      assert {:ok, person} = Humaans.Me.get(client)
      assert %Humaans.Resources.Person{} = person
      assert person.id == "person_abc"
      assert person.first_name == "Jane"
      assert person.last_name == "Doe"
    end

    test "surfaces 401 as a Humaans.Error", %{client: client} do
      expect(Humaans.MockHTTPClient, :request, fn _client, _opts ->
        {:ok, %{status: 401, body: %{"message" => "unauthorized"}}}
      end)

      assert {:error, %Humaans.Error{type: :api_error, status: 401}} = Humaans.Me.get(client)
    end
  end
end
