defmodule Humaans.Resource do
  @moduledoc """
  Macro for generating standard CRUD operations for Humaans API resources.

  Resource modules can `use Humaans.Resource` to automatically generate
  `list/2`, `create/2`, `retrieve/2`, `update/3`, and `delete/2` functions,
  reducing boilerplate while keeping each resource's behaviour explicit.

  ## Options

  * `:path` (required) - The API path prefix, e.g. `"/people"`
  * `:struct` (required) - The resource struct module, e.g. `Humaans.Resources.Person`
  * `:actions` (optional) - List of actions to generate. Defaults to all five:
    `[:list, :create, :retrieve, :update, :delete]`

  ## Examples

      defmodule Humaans.People do
        use Humaans.Resource,
          path: "/people",
          struct: Humaans.Resources.Person

        # All CRUD functions are generated automatically.
        # Override any function below if non-standard behaviour is needed.
      end

      defmodule Humaans.Companies do
        use Humaans.Resource,
          path: "/companies",
          struct: Humaans.Resources.Company,
          actions: [:list, :update]

        # Companies don't support create or delete via the API.
        # Retrieve is exposed as get/2 instead of the standard retrieve/2.
      end

  All generated functions are `defoverridable`, so resource modules can
  override individual operations without losing the generated ones.
  """

  defmacro __using__(opts) do
    path = Keyword.fetch!(opts, :path)
    struct_module = Keyword.fetch!(opts, :struct)
    actions = Keyword.get(opts, :actions, [:list, :create, :retrieve, :update, :delete])

    quote do
      alias Humaans.{Client, ResponseHandler}

      @resource_path unquote(path)
      @resource_struct unquote(struct_module)

      if :list in unquote(actions) do
        @doc """
        Lists all resources.

        Returns a list of resources matching the optional filter `params`.

        ## Parameters

          * `client` - Client map created with `Humaans.new/1`
          * `params` - Optional parameters for filtering (default: `%{}`)

        """
        @spec list(client :: map(), params :: keyword()) ::
                {:ok, [struct()]} | {:error, any()}
        def list(client, params \\ %{}) do
          Client.get(client, @resource_path, params)
          |> ResponseHandler.handle_list_response(@resource_struct)
        end

        defoverridable list: 2
      end

      if :create in unquote(actions) do
        @doc """
        Creates a new resource.

        ## Parameters

          * `client` - Client map created with `Humaans.new/1`
          * `params` - Map of parameters for the new resource

        """
        @spec create(client :: map(), params :: keyword()) ::
                {:ok, struct()} | {:error, any()}
        def create(client, params) do
          Client.post(client, @resource_path, params)
          |> ResponseHandler.handle_resource_response(@resource_struct)
        end

        defoverridable create: 2
      end

      if :retrieve in unquote(actions) do
        @doc """
        Retrieves a specific resource by ID.

        ## Parameters

          * `client` - Client map created with `Humaans.new/1`
          * `id` - String ID of the resource to retrieve

        """
        @spec retrieve(client :: map(), id :: String.t()) ::
                {:ok, struct()} | {:error, any()}
        def retrieve(client, id) do
          Client.get(client, "#{@resource_path}/#{id}")
          |> ResponseHandler.handle_resource_response(@resource_struct)
        end

        defoverridable retrieve: 2
      end

      if :update in unquote(actions) do
        @doc """
        Updates a specific resource by ID.

        ## Parameters

          * `client` - Client map created with `Humaans.new/1`
          * `id` - String ID of the resource to update
          * `params` - Map of parameters to update

        """
        @spec update(client :: map(), id :: String.t(), params :: keyword()) ::
                {:ok, struct()} | {:error, any()}
        def update(client, id, params) do
          Client.patch(client, "#{@resource_path}/#{id}", params)
          |> ResponseHandler.handle_resource_response(@resource_struct)
        end

        defoverridable update: 3
      end

      if :delete in unquote(actions) do
        @doc """
        Deletes a specific resource by ID.

        ## Parameters

          * `client` - Client map created with `Humaans.new/1`
          * `id` - String ID of the resource to delete

        """
        @spec delete(client :: map(), id :: String.t()) ::
                {:ok, %{id: String.t(), deleted: bool()}} | {:error, any()}
        def delete(client, id) do
          Client.delete(client, "#{@resource_path}/#{id}")
          |> ResponseHandler.handle_delete_response()
        end

        defoverridable delete: 2
      end
    end
  end
end
