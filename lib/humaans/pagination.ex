defmodule Humaans.Pagination do
  @moduledoc """
  Helpers for paginating through Humaans API list endpoints.

  The Humaans API uses offset-based pagination via `$limit` and `$skip`
  parameters. All list endpoints support these parameters.

  ## Page-by-page iteration

  Use `page/4` to fetch a specific page of results:

      client = Humaans.new(access_token: "token")

      {:ok, result} = Humaans.Pagination.page(client, &Humaans.People.list/2, 1, page_size: 25)
      result.data       # list of Person structs for page 1
      result.page       # 1
      result.page_size  # 25

  ## Streaming

  Use `stream/3` to lazily iterate all resources without loading everything
  into memory at once. Pages are fetched on demand and the stream stops
  automatically when the last page is reached.

      client
      |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 50)
      |> Stream.filter(&(&1.status == :active))
      |> Enum.to_list()

  Any additional options (other than `:page_size`) are forwarded to the
  `list_fn` as query parameters:

      client
      |> Humaans.Pagination.stream(
        &Humaans.Compensations.list/2,
        page_size: 100,
        personId: "person-123"
      )
      |> Enum.each(&process/1)

  """

  @default_page_size 20

  @type page_result(resource) :: %{
          data: [resource],
          page: pos_integer(),
          page_size: pos_integer()
        }

  @doc """
  Fetches a specific page of results from a list endpoint.

  `list_fn` must be a function with arity 2 that accepts a client and a params
  keyword list and returns `{:ok, [structs]} | {:error, reason}`.

  ## Parameters

  * `client` - Client map created with `Humaans.new/1`
  * `list_fn` - A 2-arity list function, e.g. `&Humaans.People.list/2`
  * `page` - Page number, 1-based
  * `opts` - Options:
    * `:page_size` - Number of results per page (default: #{@default_page_size})
    * Any other options are forwarded as query parameters to `list_fn`

  ## Examples

      {:ok, result} = Humaans.Pagination.page(client, &Humaans.People.list/2, 1, page_size: 25)
      result.data       #=> [%Person{}, ...]
      result.page       #=> 1
      result.page_size  #=> 25

  """
  @spec page(client :: map(), list_fn :: function(), page :: pos_integer(), opts :: keyword()) ::
          {:ok, page_result(struct())} | {:error, any()}
  def page(client, list_fn, page_number, opts \\ []) when page_number >= 1 do
    page_size = Keyword.get(opts, :page_size, @default_page_size)
    extra_params = Keyword.drop(opts, [:page_size])

    skip = (page_number - 1) * page_size
    params = Keyword.merge(extra_params, "$limit": page_size, "$skip": skip)

    case list_fn.(client, params) do
      {:ok, data} when is_list(data) ->
        {:ok, %{data: data, page: page_number, page_size: page_size}}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Returns a lazy `Stream` that yields all resources from a list endpoint,
  fetching pages as needed.

  The stream stops when a page returns fewer results than the page size,
  indicating the last page has been reached.

  ## Parameters

  * `client` - Client map created with `Humaans.new/1`
  * `list_fn` - A 2-arity list function, e.g. `&Humaans.People.list/2`
  * `opts` - Options:
    * `:page_size` - Number of results per page (default: #{@default_page_size})
    * Any other options are forwarded as query parameters to `list_fn`

  ## Examples

      # Stream all people, 50 at a time
      client
      |> Humaans.Pagination.stream(&Humaans.People.list/2, page_size: 50)
      |> Enum.each(fn person -> IO.puts(person.first_name) end)

      # Stream compensations for a specific person
      client
      |> Humaans.Pagination.stream(
        &Humaans.Compensations.list/2,
        page_size: 100,
        personId: "person-123"
      )
      |> Enum.to_list()

  """
  @spec stream(client :: map(), list_fn :: function(), opts :: keyword()) :: Enumerable.t()
  def stream(client, list_fn, opts \\ []) do
    page_size = Keyword.get(opts, :page_size, @default_page_size)

    Stream.resource(
      fn -> 1 end,
      fn
        :done ->
          {:halt, :done}

        page_number ->
          case page(client, list_fn, page_number, opts) do
            {:ok, %{data: []}} ->
              {:halt, :done}

            {:ok, %{data: data}} when length(data) < page_size ->
              {data, :done}

            {:ok, %{data: data}} ->
              {data, page_number + 1}

            {:error, _reason} ->
              {:halt, :done}
          end
      end,
      fn _state -> :ok end
    )
  end
end
