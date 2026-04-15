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
  * `:doc_params` (optional) - Keyword list of example param maps for `create` and/or
    `update`, as strings. Used to generate meaningful `## Examples` in the docs.
    e.g. `[create: "%{person_id: \"abc\", bank_name: \"Barclays\"}"]`

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

  # ~s(...) sigils arrive as AST tuples in a macro's opts; plain "..." binaries are self-quoting.
  defp extract_string(nil), do: nil
  defp extract_string(s) when is_binary(s), do: s
  defp extract_string({:sigil_s, _, [{:<<>>, _, [s]}, _]}) when is_binary(s), do: s

  defmacro __using__(opts) do
    path = Keyword.fetch!(opts, :path)
    struct_module = Keyword.fetch!(opts, :struct)
    actions = Keyword.get(opts, :actions, [:list, :create, :retrieve, :update, :delete])
    doc_params = Keyword.get(opts, :doc_params, [])

    caller_mod = __CALLER__.module
    struct_module_atom = Macro.expand(struct_module, __CALLER__)
    rs = struct_module_atom |> Module.split() |> List.last() |> Macro.underscore()
    rp = caller_mod |> Module.split() |> List.last() |> Macro.underscore()
    mod = inspect(caller_mod)

    cp = doc_params |> Keyword.get(:create) |> extract_string()
    up = doc_params |> Keyword.get(:update) |> extract_string()

    list_doc = """
    Lists all #{rp}.

    Returns a list of #{rp} matching the optional filter `params`.

    ## Parameters

      * `client` - Client created with `Humaans.new/1`
      * `params` - Optional map of filter parameters (default: `%{}`)

    ## Examples

        client = Humaans.new(access_token: "your_access_token")
        {:ok, #{rp}} = #{mod}.list(client)
        {:ok, #{rp}} = #{mod}.list(client, %{})

    """

    create_doc =
      if cp do
        """
        Creates a new #{rs}.

        ## Parameters

          * `client` - Client created with `Humaans.new/1`
          * `params` - Map of attributes for the new #{rs}

        ## Examples

            client = Humaans.new(access_token: "your_access_token")
            params = #{cp}
            {:ok, #{rs}} = #{mod}.create(client, params)

        """
      else
        """
        Creates a new #{rs}.

        ## Parameters

          * `client` - Client created with `Humaans.new/1`
          * `params` - Map of attributes for the new #{rs}

        ## Examples

            client = Humaans.new(access_token: "your_access_token")
            {:ok, #{rs}} = #{mod}.create(client, %{})

        """
      end

    retrieve_doc = """
    Retrieves a specific #{rs} by ID.

    ## Parameters

      * `client` - Client created with `Humaans.new/1`
      * `id` - String ID of the #{rs} to retrieve

    ## Examples

        client = Humaans.new(access_token: "your_access_token")
        {:ok, #{rs}} = #{mod}.retrieve(client, "#{rs}_id")

    """

    update_doc =
      if up do
        """
        Updates a specific #{rs} by ID.

        ## Parameters

          * `client` - Client created with `Humaans.new/1`
          * `id` - String ID of the #{rs} to update
          * `params` - Map of attributes to update

        ## Examples

            client = Humaans.new(access_token: "your_access_token")
            params = #{up}
            {:ok, #{rs}} = #{mod}.update(client, "#{rs}_id", params)

        """
      else
        """
        Updates a specific #{rs} by ID.

        ## Parameters

          * `client` - Client created with `Humaans.new/1`
          * `id` - String ID of the #{rs} to update
          * `params` - Map of attributes to update

        ## Examples

            client = Humaans.new(access_token: "your_access_token")
            {:ok, #{rs}} = #{mod}.update(client, "#{rs}_id", %{})

        """
      end

    delete_doc = """
    Deletes a specific #{rs} by ID.

    ## Parameters

      * `client` - Client created with `Humaans.new/1`
      * `id` - String ID of the #{rs} to delete

    ## Examples

        client = Humaans.new(access_token: "your_access_token")
        {:ok, %{id: "#{rs}_id", deleted: true}} = #{mod}.delete(client, "#{rs}_id")

    """

    quote do
      alias Humaans.{Client, ResponseHandler}

      @resource_path unquote(path)
      @resource_struct unquote(struct_module)

      if :list in unquote(actions) do
        @doc unquote(list_doc)
        @spec list(client :: map(), params :: map() | keyword()) ::
                {:ok, [unquote(struct_module).t()]} | {:error, Humaans.Error.t()}
        def list(client, params \\ %{}) do
          Client.get(client, @resource_path, params)
          |> ResponseHandler.handle_list_response(@resource_struct)
        end

        defoverridable list: 2
      end

      if :create in unquote(actions) do
        @doc unquote(create_doc)
        @spec create(client :: map(), params :: map() | keyword()) ::
                {:ok, unquote(struct_module).t()} | {:error, Humaans.Error.t()}
        def create(client, params) do
          Client.post(client, @resource_path, params)
          |> ResponseHandler.handle_resource_response(@resource_struct)
        end

        defoverridable create: 2
      end

      if :retrieve in unquote(actions) do
        @doc unquote(retrieve_doc)
        @spec retrieve(client :: map(), id :: String.t()) ::
                {:ok, unquote(struct_module).t()} | {:error, Humaans.Error.t()}
        def retrieve(client, id) do
          Client.get(client, "#{@resource_path}/#{id}")
          |> ResponseHandler.handle_resource_response(@resource_struct)
        end

        defoverridable retrieve: 2
      end

      if :update in unquote(actions) do
        @doc unquote(update_doc)
        @spec update(client :: map(), id :: String.t(), params :: map() | keyword()) ::
                {:ok, unquote(struct_module).t()} | {:error, Humaans.Error.t()}
        def update(client, id, params) do
          Client.patch(client, "#{@resource_path}/#{id}", params)
          |> ResponseHandler.handle_resource_response(@resource_struct)
        end

        defoverridable update: 3
      end

      if :delete in unquote(actions) do
        @doc unquote(delete_doc)
        @spec delete(client :: map(), id :: String.t()) ::
                {:ok, %{id: String.t(), deleted: boolean()}} | {:error, Humaans.Error.t()}
        def delete(client, id) do
          Client.delete(client, "#{@resource_path}/#{id}")
          |> ResponseHandler.handle_delete_response()
        end

        defoverridable delete: 2
      end
    end
  end
end
