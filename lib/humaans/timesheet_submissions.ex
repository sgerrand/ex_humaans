defmodule Humaans.TimesheetSubmissions do
  @moduledoc """
  This module provides functions for managing timesheet submission resources in
  the Humaans API. Timesheet submissions represent a collection of timesheet
  entries for a specific time period that has been submitted for review and
  approval.
  """

  alias Humaans.{Client, Resources.TimesheetSubmission}

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%TimesheetSubmission{}]} | {:error, any()}
  @type response :: {:ok, %TimesheetSubmission{}} | {:error, any()}

  @callback list(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback create(client :: map(), map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(client :: map(), String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(client :: map(), String.t()) :: {:ok, map()} | {:error, any()}

  @doc """
  Lists all timesheet submission resources.

  Returns a list of timesheet submission resources that match the optional filters provided in `params`.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Optional parameters for filtering the results (default: `%{}`)

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      # List all timesheet submissions
      {:ok, submissions} = Humaans.TimesheetSubmissions.list(client)

      # List with filtering parameters
      {:ok, submissions} = Humaans.TimesheetSubmissions.list(client, %{personId: "person_id"})

  """
  @spec list(client :: map(), params :: keyword()) :: list_response()
  def list(client, params \\ %{}) do
    Client.get(client, "/timesheet-submissions", params)
    |> handle_response()
  end

  @doc """
  Creates a new timesheet submission resource.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `params` - Map of parameters for the new timesheet submission

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{
        personId: "person_id",
        startDate: "2023-01-01",
        endDate: "2023-01-31",
        status: "pending"
      }

      {:ok, submission} = Humaans.TimesheetSubmissions.create(client, params)

  """
  @spec create(client :: map(), params :: keyword()) :: response()
  def create(client, params) do
    Client.post(client, "/timesheet-submissions", params)
    |> handle_response()
  end

  @doc """
  Retrieves a specific timesheet submission by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the timesheet submission to retrieve

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, submission} = Humaans.TimesheetSubmissions.retrieve(client, "submission_id")

  """
  @spec retrieve(client :: map(), id :: String.t()) :: response()
  def retrieve(client, id) do
    Client.get(client, "/timesheet-submissions/#{id}")
    |> handle_response()
  end

  @doc """
  Updates a specific timesheet submission by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the timesheet submission to update
    * `params` - Map of parameters to update

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      params = %{status: "approved"}

      {:ok, updated_submission} = Humaans.TimesheetSubmissions.update(client, "submission_id", params)

  """
  @spec update(client :: map(), id :: String.t(), params :: keyword()) :: response()
  def update(client, id, params) do
    Client.patch(client, "/timesheet-submissions/#{id}", params)
    |> handle_response()
  end

  @doc """
  Deletes a specific timesheet submission by ID.

  ## Parameters

    * `client` - Client map created with `Humaans.new/1`
    * `id` - String ID of the timesheet submission to delete

  ## Examples

      client = Humaans.new(access_token: "your_access_token")

      {:ok, result} = Humaans.TimesheetSubmissions.delete(client, "submission_id")
      # result contains %{id: "submission_id", deleted: true}

  """
  @spec delete(client :: map(), id :: String.t()) :: delete_response()
  def delete(client, id) do
    Client.delete(client, "/timesheet-submissions/#{id}")
    |> handle_response()
  end

  defp handle_response({:ok, %{status: status, body: %{"data" => data}}})
       when status in 200..299 do
    {_r, response} =
      Enum.map_reduce(data, [], fn i, acc ->
        {TimesheetSubmission.new(i), [TimesheetSubmission.new(i) | acc]}
      end)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: %{"deleted" => deleted, "id" => id}}})
       when status in 200..299 do
    {:ok, %{deleted: deleted, id: id}}
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299 do
    response = TimesheetSubmission.new(body)

    {:ok, response}
  end

  defp handle_response({:ok, %{status: status, body: body}}) do
    {:error, {status, body}}
  end

  defp handle_response({:error, _} = error), do: error
end
