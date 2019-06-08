defmodule Blockquote.AdminTest do
  use Blockquote.DataCase

  alias Blockquote.Admin

  describe "authors" do
    alias Blockquote.Admin.Author

    @valid_attrs %{first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name"}
    @invalid_attrs %{first_name: nil, last_name: nil, middle_name: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Admin.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Admin.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Admin.create_author(@valid_attrs)
      assert author.first_name == "some first_name"
      assert author.last_name == "some last_name"
      assert author.middle_name == "some middle_name"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, author} = Admin.update_author(author, @update_attrs)
      assert %Author{} = author
      assert author.first_name == "some updated first_name"
      assert author.last_name == "some updated last_name"
      assert author.middle_name == "some updated middle_name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_author(author, @invalid_attrs)
      assert author == Admin.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Admin.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Admin.change_author(author)
    end
  end

  describe "categories" do
    alias Blockquote.Admin.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Admin.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Admin.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Admin.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Admin.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_category(category, @invalid_attrs)
      assert category == Admin.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Admin.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Admin.change_category(category)
    end
  end

  describe "source_types" do
    alias Blockquote.Admin.SourceType

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def source_type_fixture(attrs \\ %{}) do
      {:ok, source_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_source_type()

      source_type
    end

    test "list_source_types/0 returns all source_types" do
      source_type = source_type_fixture()
      assert Admin.list_source_types() == [source_type]
    end

    test "get_source_type!/1 returns the source_type with given id" do
      source_type = source_type_fixture()
      assert Admin.get_source_type!(source_type.id) == source_type
    end

    test "create_source_type/1 with valid data creates a source_type" do
      assert {:ok, %SourceType{} = source_type} = Admin.create_source_type(@valid_attrs)
      assert source_type.name == "some name"
    end

    test "create_source_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_source_type(@invalid_attrs)
    end

    test "update_source_type/2 with valid data updates the source_type" do
      source_type = source_type_fixture()
      assert {:ok, source_type} = Admin.update_source_type(source_type, @update_attrs)
      assert %SourceType{} = source_type
      assert source_type.name == "some updated name"
    end

    test "update_source_type/2 with invalid data returns error changeset" do
      source_type = source_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_source_type(source_type, @invalid_attrs)
      assert source_type == Admin.get_source_type!(source_type.id)
    end

    test "delete_source_type/1 deletes the source_type" do
      source_type = source_type_fixture()
      assert {:ok, %SourceType{}} = Admin.delete_source_type(source_type)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_source_type!(source_type.id) end
    end

    test "change_source_type/1 returns a source_type changeset" do
      source_type = source_type_fixture()
      assert %Ecto.Changeset{} = Admin.change_source_type(source_type)
    end
  end

  describe "parent_sources" do
    alias Blockquote.Admin.ParentSource

    @valid_attrs %{subtitle: "some subtitle", title: "some title", url: "some url"}
    @update_attrs %{subtitle: "some updated subtitle", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{subtitle: nil, title: nil, url: nil}

    def parent_source_fixture(attrs \\ %{}) do
      {:ok, parent_source} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_parent_source()

      parent_source
    end

    test "list_parent_sources/0 returns all parent_sources" do
      parent_source = parent_source_fixture()
      assert Admin.list_parent_sources() == [parent_source]
    end

    test "get_parent_source!/1 returns the parent_source with given id" do
      parent_source = parent_source_fixture()
      assert Admin.get_parent_source!(parent_source.id) == parent_source
    end

    test "create_parent_source/1 with valid data creates a parent_source" do
      assert {:ok, %ParentSource{} = parent_source} = Admin.create_parent_source(@valid_attrs)
      assert parent_source.subtitle == "some subtitle"
      assert parent_source.title == "some title"
      assert parent_source.url == "some url"
    end

    test "create_parent_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_parent_source(@invalid_attrs)
    end

    test "update_parent_source/2 with valid data updates the parent_source" do
      parent_source = parent_source_fixture()
      assert {:ok, parent_source} = Admin.update_parent_source(parent_source, @update_attrs)
      assert %ParentSource{} = parent_source
      assert parent_source.subtitle == "some updated subtitle"
      assert parent_source.title == "some updated title"
      assert parent_source.url == "some updated url"
    end

    test "update_parent_source/2 with invalid data returns error changeset" do
      parent_source = parent_source_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_parent_source(parent_source, @invalid_attrs)
      assert parent_source == Admin.get_parent_source!(parent_source.id)
    end

    test "delete_parent_source/1 deletes the parent_source" do
      parent_source = parent_source_fixture()
      assert {:ok, %ParentSource{}} = Admin.delete_parent_source(parent_source)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_parent_source!(parent_source.id) end
    end

    test "change_parent_source/1 returns a parent_source changeset" do
      parent_source = parent_source_fixture()
      assert %Ecto.Changeset{} = Admin.change_parent_source(parent_source)
    end
  end

  describe "sources" do
    alias Blockquote.Admin.Source

    @valid_attrs %{subtitle: "some subtitle", title: "some title", url: "some url"}
    @update_attrs %{subtitle: "some updated subtitle", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{subtitle: nil, title: nil, url: nil}

    def source_fixture(attrs \\ %{}) do
      {:ok, source} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_source()

      source
    end

    test "list_sources/0 returns all sources" do
      source = source_fixture()
      assert Admin.list_sources() == [source]
    end

    test "get_source!/1 returns the source with given id" do
      source = source_fixture()
      assert Admin.get_source!(source.id) == source
    end

    test "create_source/1 with valid data creates a source" do
      assert {:ok, %Source{} = source} = Admin.create_source(@valid_attrs)
      assert source.subtitle == "some subtitle"
      assert source.title == "some title"
      assert source.url == "some url"
    end

    test "create_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_source(@invalid_attrs)
    end

    test "update_source/2 with valid data updates the source" do
      source = source_fixture()
      assert {:ok, source} = Admin.update_source(source, @update_attrs)
      assert %Source{} = source
      assert source.subtitle == "some updated subtitle"
      assert source.title == "some updated title"
      assert source.url == "some updated url"
    end

    test "update_source/2 with invalid data returns error changeset" do
      source = source_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_source(source, @invalid_attrs)
      assert source == Admin.get_source!(source.id)
    end

    test "delete_source/1 deletes the source" do
      source = source_fixture()
      assert {:ok, %Source{}} = Admin.delete_source(source)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_source!(source.id) end
    end

    test "change_source/1 returns a source changeset" do
      source = source_fixture()
      assert %Ecto.Changeset{} = Admin.change_source(source)
    end
  end

  describe "quotes" do
    alias Blockquote.Admin.Quote

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def quote_fixture(attrs \\ %{}) do
      {:ok, quote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_quote()

      quote
    end

    test "list_quotes/0 returns all quotes" do
      quote = quote_fixture()
      assert Admin.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = quote_fixture()
      assert Admin.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      assert {:ok, %Quote{} = quote} = Admin.create_quote(@valid_attrs)
      assert quote.body == "some body"
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = quote_fixture()
      assert {:ok, quote} = Admin.update_quote(quote, @update_attrs)
      assert %Quote{} = quote
      assert quote.body == "some updated body"
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_quote(quote, @invalid_attrs)
      assert quote == Admin.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{}} = Admin.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = quote_fixture()
      assert %Ecto.Changeset{} = Admin.change_quote(quote)
    end
  end

  describe "daily_quotes" do
    alias Blockquote.Admin.DailyQuote

    @valid_attrs %{date_used: ~D[2010-04-17]}
    @update_attrs %{date_used: ~D[2011-05-18]}
    @invalid_attrs %{date_used: nil}

    def daily_quote_fixture(attrs \\ %{}) do
      {:ok, daily_quote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_daily_quote()

      daily_quote
    end

    test "list_daily_quotes/0 returns all daily_quotes" do
      daily_quote = daily_quote_fixture()
      assert Admin.list_daily_quotes() == [daily_quote]
    end

    test "get_daily_quote!/1 returns the daily_quote with given id" do
      daily_quote = daily_quote_fixture()
      assert Admin.get_daily_quote!(daily_quote.id) == daily_quote
    end

    test "create_daily_quote/1 with valid data creates a daily_quote" do
      assert {:ok, %DailyQuote{} = daily_quote} = Admin.create_daily_quote(@valid_attrs)
      assert daily_quote.date_used == ~D[2010-04-17]
    end

    test "create_daily_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_daily_quote(@invalid_attrs)
    end

    test "update_daily_quote/2 with valid data updates the daily_quote" do
      daily_quote = daily_quote_fixture()
      assert {:ok, daily_quote} = Admin.update_daily_quote(daily_quote, @update_attrs)
      assert %DailyQuote{} = daily_quote
      assert daily_quote.date_used == ~D[2011-05-18]
    end

    test "update_daily_quote/2 with invalid data returns error changeset" do
      daily_quote = daily_quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_daily_quote(daily_quote, @invalid_attrs)
      assert daily_quote == Admin.get_daily_quote!(daily_quote.id)
    end

    test "delete_daily_quote/1 deletes the daily_quote" do
      daily_quote = daily_quote_fixture()
      assert {:ok, %DailyQuote{}} = Admin.delete_daily_quote(daily_quote)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_daily_quote!(daily_quote.id) end
    end

    test "change_daily_quote/1 returns a daily_quote changeset" do
      daily_quote = daily_quote_fixture()
      assert %Ecto.Changeset{} = Admin.change_daily_quote(daily_quote)
    end
  end
end
