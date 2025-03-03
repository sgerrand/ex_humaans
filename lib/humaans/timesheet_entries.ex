defmodule Humaans.TimesheetEntries do
  @moduledoc """
  This module provides functions for managing timesheet entry resources in the
  Humaans API. Timesheet entries represent individual time records for a person,
  such as hours worked on a specific date.
  """

  alias Humaans.{Client, Resources.TimesheetEntry}

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%TimesheetEntry{}]} | {:error, any()}
  @type response :: {:ok, %TimesheetEntry{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback create(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all timesheet entry resources.

  Returns a list of timesheet entry resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all timesheet entries
      {:ok, entries} = Humaans.TimesheetEntries.list(client)

      # List with filtering parameters
      {:ok, entries} = Humaans.TimesheetEntries.list(client, %{personId: "person_id"})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/timesheet-entries", params)
    |> handle_response()
  end

  @doc """
  Creates a new timesheet entry resource.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Map of parameters for the new timesheet entry

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{
        personId: "person_id",
        date: "2023-01-10",
        startTime: "09:00:00",
        endTime: "17:00:00"
      }

      {:ok, entry} = Humaans.TimesheetEntries.create(client, params)

  """
  @spec create(client :: map(), params :: keyword()) :: response()
  def create(client, params) do
    Client.post(client, "/timesheet-entries", params)
    |> handle_response()
  end

  @doc """
  Retrieves a specific timesheet entry by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the timesheet entry to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, entry} = Humaans.TimesheetEntries.retrieve(client, "entry_id")

  """
  @spec retrieve(client :: map(), id :: String.t()) :: response()
  def retrieve(client, id) do
    Client.get(client, "/timesheet-entries/#{id}")
    |> handle_response()
  end

  @doc """
  Updates a specific timesheet entry by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the timesheet entry to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{startTime: "10:00:00", endTime: "18:00:00"}

      {:ok, updated_entry} = Humaans.TimesheetEntries.update(client, "entry_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/timesheet-entries/#{id}", params)
    |> handle_response()
  end

  @doc """
  Deletes a specific timesheet entry by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the timesheet entry to delete

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, result} = Humaans.TimesheetEntries.delete(client, "entry_id")
      # result contains %{id: "entry_id", deleted: true}

  """
  @spec delete(client :: map(), id :: String.t()) :: delete_response()
  def delete(client, id) do
    Client.delete(client, "/timesheet-entries/#{id}")
    |> handle_response()
  end

  defp handle_response({:ok, %{status: status, body: %{"data" => data}}})
       when status in 200..299 do
    {_r, response} =
      Enum.map_reduce(data, [], fn i, acc ->
        {TimesheetEntry.new(i), [TimesheetEntry.new(i) | acc]}
      end)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: %{"deleted" => deleted, "id" => id}}})
       when status in 200..299 do
    {:ok, %{deleted: deleted, id: id}}
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    response = TimesheetEntry.new(body)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error
end
