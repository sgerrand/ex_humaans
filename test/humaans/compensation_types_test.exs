defmodule Humaans.CompensationTypesTest do
  use ExUnit.Case, async: true
  import Mox

  doctest Humaans.CompensationTypes

  setup :verify_on_exit!

  describe "list/1" do
    test "returns a list of compensation types" do
      expect(Humaans.MockClient, :get, fn path, _params ->
        assert path == "/compensation-types"

        {:ok,
         %{
           status: 200,
           body: %{
             "total" => 1,
             "limit" => 100,
             "skip" => 0,
             "data" => [
               %{
                 "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
                 "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
                 "name" => "Salary",
                 "baseType" => "salary",
                 "createdAt" => "2020-01-28T08:44:42.000Z",
                 "updatedAt" => "2020-01-29T14:52:21.000Z"
               }
             ]
           }
         }}
      end)

      assert {:ok, response} = Humaans.CompensationTypes.list()
      assert length(response) == 1
      assert hd(response).id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert hd(response).company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert hd(response).name == "Salary"
      assert hd(response).base_type == "salary"
      assert hd(response).created_at == "2020-01-28T08:44:42.000Z"
      assert hd(response).updated_at == "2020-01-29T14:52:21.000Z"
    end

    test "returns error when resource is not found" do
      expect(Humaans.MockClient, :get, fn _path, _params ->
        {:ok, %{status: 404, body: %{"error" => "Compensation Type not found"}}}
      end)

      assert {:error, {404, %{"error" => "Compensation Type not found"}}} ==
               Humaans.CompensationTypes.list()
    end

    test "returns error when request fails" do
      expect(Humaans.MockClient, :get, fn _path, _params ->
        {:error, "something unexpected happened"}
      end)

      assert {:error, "something unexpected happened"} ==
               Humaans.CompensationTypes.list()
    end
  end

  describe "create/1" do
    test "creates a new compensation type" do
      params = %{
        "name" => "Salary"
      }

      expect(Humaans.MockClient, :post, fn path, ^params ->
        assert path == "/compensation-types"

        {:ok,
         %{
           status: 201,
           body: %{
             "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "name" => "Salary",
             "baseType" => "salary",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CompensationTypes.create(params)
      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "retrieve/1" do
    test "retrieves a compensation type" do
      expect(Humaans.MockClient, :get, fn path ->
        assert path == "/compensation-types/ldOQU3pLI5i8Y9k2rJbrXbFc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "name" => "Salary",
             "baseType" => "salary",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} = Humaans.CompensationTypes.retrieve("ldOQU3pLI5i8Y9k2rJbrXbFc")
      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "update/2" do
    test "updates a compensation type" do
      params = %{"name" => "New Salary"}

      expect(Humaans.MockClient, :patch, fn path, ^params ->
        assert path == "/compensation-types/ldOQU3pLI5i8Y9k2rJbrXbFc"

        {:ok,
         %{
           status: 200,
           body: %{
             "id" => "ldOQU3pLI5i8Y9k2rJbrXbFc",
             "companyId" => "T7uqPFK7am4lFTZm39AmNuay",
             "name" => "New Salary",
             "baseType" => "salary",
             "createdAt" => "2020-01-28T08:44:42.000Z",
             "updatedAt" => "2020-01-29T14:52:21.000Z"
           }
         }}
      end)

      assert {:ok, response} =
               Humaans.CompensationTypes.update("ldOQU3pLI5i8Y9k2rJbrXbFc", params)

      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.company_id == "T7uqPFK7am4lFTZm39AmNuay"
      assert response.name == "New Salary"
      assert response.base_type == "salary"
      assert response.created_at == "2020-01-28T08:44:42.000Z"
      assert response.updated_at == "2020-01-29T14:52:21.000Z"
    end
  end

  describe "delete/1" do
    test "deletes a compensation type" do
      expect(Humaans.MockClient, :delete, fn path ->
        assert path == "/compensation-types/ldOQU3pLI5i8Y9k2rJbrXbFc"

        {:ok, %{status: 200, body: %{"id" => "ldOQU3pLI5i8Y9k2rJbrXbFc", "deleted" => true}}}
      end)

      assert {:ok, response} = Humaans.CompensationTypes.delete("ldOQU3pLI5i8Y9k2rJbrXbFc")
      assert response.id == "ldOQU3pLI5i8Y9k2rJbrXbFc"
      assert response.deleted == true
    end
  end
end
