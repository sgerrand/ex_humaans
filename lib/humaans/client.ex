defmodule Humaans.Client do
  @moduledoc false

  alias Humaans.Response

  @impl_module Application.compile_env(:humaans, :client, Humaans.Client.Req)

  @callback delete(client :: map(), nonempty_binary()) :: Response.t()
  defdelegate delete(client, path), to: @impl_module

  @callback get(client :: map(), nonempty_binary()) :: Response.t()
  defdelegate get(client, path), to: @impl_module

  @callback get(client :: map(), nonempty_binary(), keyword()) :: Response.t()
  defdelegate get(client, path, params), to: @impl_module

  @callback post(client :: map(), nonempty_binary(), keyword()) :: Response.t()
  defdelegate post(client, path, params \\ []), to: @impl_module

  @callback patch(client :: map(), nonempty_binary(), keyword()) :: Response.t()
  defdelegate patch(client, path, params \\ []), to: @impl_module
end
