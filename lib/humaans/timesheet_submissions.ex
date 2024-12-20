defmodule Humaans.TimesheetSubmissions do
  @moduledoc """
  Handles operations related to timesheet submissions.
  """

  alias Humaans.Resources.TimesheetSubmission

  @type delete_response :: {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
  @type list_response :: {:ok, [%TimesheetSubmission{}]} | {:error, any()}
  @type response :: {:ok, %TimesheetSubmission{}} | {:error, any()}

  @callback list(map()) :: {:ok, map()} | {:error, any()}
  @callback create(map()) :: {:ok, map()} | {:error, any()}
  @callback retrieve(String.t()) :: {:ok, map()} | {:error, any()}
  @callback update(String.t(), map()) :: {:ok, map()} | {:error, any()}
  @callback delete(String.t()) :: {:ok, map()} | {:error, any()}

  @client Application.compile_env!(:humaans, :client)

  @spec list(params :: keyword()) :: list_response()
  def list(params \\ %{}) do
    @client.get("/timesheet-submissions", params)
    |> handle_response()
  end

  @spec create(params :: keyword()) :: response()
  def create(params) do
    @client.post("/timesheet-submissions", params)
    |> handle_response()
  end

  @spec retrieve(id :: String.t()) :: response()
  def retrieve(id) do
    @client.get("/timesheet-submissions/#{id}")
    |> handle_response()
  end

  @spec update(id :: String.t(), params :: keyword()) :: response()
  def update(id, params) do
    @client.patch("/timesheet-submissions/#{id}", params)
    |> handle_response()
  end

  @spec delete(id :: String.t()) :: delete_response()
  def delete(id) do
    @client.delete("/timesheet-submissions/#{id}")
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
