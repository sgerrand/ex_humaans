defmodule Humaans.Client do
  @moduledoc false

  alias Humaans.Response

  @impl_module Application.compile_env!(:humaans, :client)

  @callback delete(nonempty_binary()) :: Response.t()
  defdelegate delete(path), to: @impl_module

  @callback get(nonempty_binary()) :: Response.t()
  defdelegate get(path), to: @impl_module

  @callback get(nonempty_binary(), keyword()) :: Response.t()
  defdelegate get(path, params), to: @impl_module

  @callback post(nonempty_binary(), keyword()) :: Response.t()
  defdelegate post(path, params \\ []), to: @impl_module

  @callback patch(nonempty_binary(), keyword()) :: Response.t()
  defdelegate patch(path, params \\ []), to: @impl_module
end
