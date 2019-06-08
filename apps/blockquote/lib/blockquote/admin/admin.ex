defmodule Blockquote.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Blockquote.Repo

  alias Blockquote.Admin.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(from(Author, order_by: [:last_name, :first_name, :middle_name]))
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)
  
  @doc """
  Gets a single author for show pages.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  """
  def get_author_for_show!(id), do: Repo.get!(Author, id) |> Repo.preload([:quotes, {:sources, [:quotes]}])

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  alias Blockquote.Admin.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(from(Category, order_by: :name))
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)
  
  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  """
  def get_category_for_show!(id), do: Repo.get!(Category, id) |> Repo.preload([:quotes])

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  alias Blockquote.Admin.SourceType

  @doc """
  Returns the list of source_types.

  ## Examples

      iex> list_source_types()
      [%SourceType{}, ...]

  """
  def list_source_types do
    Repo.all(from(SourceType, order_by: :name))
  end

  @doc """
  Gets a single source_type.

  Raises `Ecto.NoResultsError` if the Source type does not exist.

  ## Examples

      iex> get_source_type!(123)
      %SourceType{}

      iex> get_source_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_source_type!(id), do: Repo.get!(SourceType, id)
  
  @doc """
  Gets a single source_type.

  Raises `Ecto.NoResultsError` if the Source type does not exist.

  """
  def get_source_type_for_show!(id), do: Repo.get!(SourceType, id) |> Repo.preload([:sources, :parent_sources])

  @doc """
  Creates a source_type.

  ## Examples

      iex> create_source_type(%{field: value})
      {:ok, %SourceType{}}

      iex> create_source_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source_type(attrs \\ %{}) do
    %SourceType{}
    |> SourceType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a source_type.

  ## Examples

      iex> update_source_type(source_type, %{field: new_value})
      {:ok, %SourceType{}}

      iex> update_source_type(source_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_source_type(%SourceType{} = source_type, attrs) do
    source_type
    |> SourceType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SourceType.

  ## Examples

      iex> delete_source_type(source_type)
      {:ok, %SourceType{}}

      iex> delete_source_type(source_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_source_type(%SourceType{} = source_type) do
    Repo.delete(source_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source_type changes.

  ## Examples

      iex> change_source_type(source_type)
      %Ecto.Changeset{source: %SourceType{}}

  """
  def change_source_type(%SourceType{} = source_type) do
    SourceType.changeset(source_type, %{})
  end

  alias Blockquote.Admin.ParentSource

  @doc """
  Returns the list of parent_sources.

  ## Examples

      iex> list_parent_sources()
      [%ParentSource{}, ...]

  """
  def list_parent_sources do
    Repo.all(from(ParentSource, order_by: [:sort_title, :subtitle]))
  end

  @doc """
  Gets a single parent_source.

  Raises `Ecto.NoResultsError` if the Parent source does not exist.

  ## Examples

      iex> get_parent_source!(123)
      %ParentSource{}

      iex> get_parent_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parent_source!(id), do: Repo.get!(ParentSource, id)
  
  @doc """
  Gets a single parent_source.

  Raises `Ecto.NoResultsError` if the Parent source does not exist.

  """
  def get_parent_source_for_show!(id), do: Repo.get!(ParentSource, id) |> Repo.preload([:sources, :source_type])

  @doc """
  Creates a parent_source.

  ## Examples

      iex> create_parent_source(%{field: value})
      {:ok, %ParentSource{}}

      iex> create_parent_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parent_source(attrs \\ %{}) do
    %ParentSource{}
    |> ParentSource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a parent_source.

  ## Examples

      iex> update_parent_source(parent_source, %{field: new_value})
      {:ok, %ParentSource{}}

      iex> update_parent_source(parent_source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parent_source(%ParentSource{} = parent_source, attrs) do
    parent_source
    |> ParentSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ParentSource.

  ## Examples

      iex> delete_parent_source(parent_source)
      {:ok, %ParentSource{}}

      iex> delete_parent_source(parent_source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parent_source(%ParentSource{} = parent_source) do
    Repo.delete(parent_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parent_source changes.

  ## Examples

      iex> change_parent_source(parent_source)
      %Ecto.Changeset{source: %ParentSource{}}

  """
  def change_parent_source(%ParentSource{} = parent_source) do
    ParentSource.changeset(parent_source, %{})
  end

  alias Blockquote.Admin.Source

  @doc """
  Returns the list of sources.

  ## Examples

      iex> list_sources()
      [%Source{}, ...]

  """
  def list_sources do
    Repo.all(from(Source, order_by: [:sort_title, :subtitle]))
  end

  @doc """
  Gets a single source.

  Raises `Ecto.NoResultsError` if the Source does not exist.

  ## Examples

      iex> get_source!(123)
      %Source{}

      iex> get_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_source!(id), do: Repo.get!(Source, id)
  
  @doc """
  Gets a single source.

  Raises `Ecto.NoResultsError` if the Source does not exist.

  """
  def get_source_for_show!(id), do: Repo.get!(Source, id) |> Repo.preload([:source_type, :quotes, :author, :parent_source])

  @doc """
  Creates a source.

  ## Examples

      iex> create_source(%{field: value})
      {:ok, %Source{}}

      iex> create_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source(attrs \\ %{}) do
    %Source{}
    |> Source.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a source.

  ## Examples

      iex> update_source(source, %{field: new_value})
      {:ok, %Source{}}

      iex> update_source(source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_source(%Source{} = source, attrs) do
    source
    |> Source.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Source.

  ## Examples

      iex> delete_source(source)
      {:ok, %Source{}}

      iex> delete_source(source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_source(%Source{} = source) do
    Repo.delete(source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source changes.

  ## Examples

      iex> change_source(source)
      %Ecto.Changeset{source: %Source{}}

  """
  def change_source(%Source{} = source) do
    Source.changeset(source, %{})
  end

  alias Blockquote.Admin.Quote

  @doc """
  Returns the list of quotes.

  ## Examples

      iex> list_quotes()
      [%Quote{}, ...]

  """
  def list_quotes do
    Repo.all(from(Quote, order_by: [desc: :id]))
  end

  @doc """
  Gets a single quote.

  Raises `Ecto.NoResultsError` if the Quote does not exist.

  ## Examples

      iex> get_quote!(123)
      %Quote{}

      iex> get_quote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quote!(id), do: Repo.get!(Quote, id)
  
  @doc """
  Gets a single quote for show pages.

  Raises `Ecto.NoResultsError` if the Quote does not exist.

  """
  def get_quote_for_show!(id), do: Repo.get!(Quote, id) |> Repo.preload([:category, :author, {:source, [:author]}])

  @doc """
  Creates a quote.

  ## Examples

      iex> create_quote(%{field: value})
      {:ok, %Quote{}}

      iex> create_quote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quote(attrs \\ %{}) do
    %Quote{}
    |> Quote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quote.

  ## Examples

      iex> update_quote(quote, %{field: new_value})
      {:ok, %Quote{}}

      iex> update_quote(quote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quote(%Quote{} = quote, attrs) do
    quote
    |> Quote.changeset(attrs)
    |> Repo.update()
  end
  
  @doc """
  Gets the changeset used for creating a quote

  """
  def create_quote_changeset(attrs \\ %{}) do
    %Quote{}
    |> Quote.changeset(attrs)
  end

  @doc """
  Gets the changeset used for updating a quote.
  """
  def update_quote_changeset(%Quote{} = quote, attrs) do
    quote
    |> Quote.changeset(attrs)
  end

  @doc """
  Deletes a Quote.

  ## Examples

      iex> delete_quote(quote)
      {:ok, %Quote{}}

      iex> delete_quote(quote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quote(%Quote{} = quote) do
    Repo.delete(quote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quote changes.

  ## Examples

      iex> change_quote(quote)
      %Ecto.Changeset{source: %Quote{}}

  """
  def change_quote(%Quote{} = quote) do
    Quote.changeset(quote, %{})
  end

  alias Blockquote.Admin.DailyQuote

  @doc """
  Returns the list of daily_quotes.

  ## Examples

      iex> list_daily_quotes()
      [%DailyQuote{}, ...]

  """
  def list_daily_quotes do
    Repo.all(from(DailyQuote, order_by: [desc: :id]))
  end
  
  @doc """
  Returns the list of daily_quotes for index pages.

  """
  def list_daily_quotes_for_index do
    Repo.all(from(DailyQuote, order_by: [desc: :id])) |> Repo.preload([:quote])
  end

  @doc """
  Gets a single daily_quote.

  Raises `Ecto.NoResultsError` if the Daily quote does not exist.

  ## Examples

      iex> get_daily_quote!(123)
      %DailyQuote{}

      iex> get_daily_quote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_quote!(id), do: Repo.get!(DailyQuote, id)
  
  @doc """
  Gets a single daily_quote for index pages.

  """
  def get_daily_quote_for_show!(id), do: Repo.get!(DailyQuote, id) |> Repo.preload([:quote])

  @doc """
  Creates a daily_quote.

  ## Examples

      iex> create_daily_quote(%{field: value})
      {:ok, %DailyQuote{}}

      iex> create_daily_quote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_quote(attrs \\ %{}) do
    %DailyQuote{}
    |> DailyQuote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a daily_quote.

  ## Examples

      iex> update_daily_quote(daily_quote, %{field: new_value})
      {:ok, %DailyQuote{}}

      iex> update_daily_quote(daily_quote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_quote(%DailyQuote{} = daily_quote, attrs) do
    daily_quote
    |> DailyQuote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a DailyQuote.

  ## Examples

      iex> delete_daily_quote(daily_quote)
      {:ok, %DailyQuote{}}

      iex> delete_daily_quote(daily_quote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_quote(%DailyQuote{} = daily_quote) do
    Repo.delete(daily_quote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_quote changes.

  ## Examples

      iex> change_daily_quote(daily_quote)
      %Ecto.Changeset{source: %DailyQuote{}}

  """
  def change_daily_quote(%DailyQuote{} = daily_quote) do
    DailyQuote.changeset(daily_quote, %{})
  end
end
