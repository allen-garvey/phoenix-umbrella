defmodule BooklistWeb.BookController do
  use BooklistWeb, :controller

  alias Booklist.Admin
  alias Booklist.Admin.Book

  def related_fields() do
    genres = Admin.list_genres()
    authors = Admin.list_authors()

    [
      authors_raw: authors,
      #add empty item at start of authors since it is optional
      authors: authors |> BooklistWeb.AuthorView.map_for_form |> List.insert_at(0, {"", nil}),
      genres: genres |> BooklistWeb.GenreView.map_for_form,
      genres_is_fiction_map: genres |> BooklistWeb.GenreView.to_is_fiction_map,
    ]
  end

  def index(conn, %{"active" => is_active, "location" => "false"}) do
    books = Admin.list_books_no_location(is_active == "true")
    render(conn, "index.html", books: books)
  end

  def index(conn, %{"active" => is_active, "read" => is_read}) do
    books = Admin.list_books_by_active_and_read(is_active == "true", is_read == "true")
    render(conn, "index.html", books: books)
  end

  def index(conn, %{"active" => is_active}) do
    books = Admin.list_books_active(is_active == "true")
    render(conn, "index.html", books: books)
  end

  def index(conn, %{"read" => is_read}) do
    books = Admin.list_books_read(is_read == "true")
    render(conn, "index.html", books: books)
  end

  def index(conn, _params) do
    books = Admin.list_books()
    render(conn, "index.html", books: books)
  end

  def new(conn, %{"author" => author_id}) do
    fields = related_fields()
    # Extract author and genre from related fields instead of doing fresh queries
    author_id_int = String.to_integer(author_id)
    author = Keyword.get(fields, :authors_raw) |> Enum.find(fn author -> author.id == author_id_int end)
    genre_is_fiction_tuple = Keyword.get(fields, :genres_is_fiction_map) |> Enum.find(fn {genre_id, _} -> genre_id == author.genre_id end)

    is_fiction = case genre_is_fiction_tuple do
      {_, genre_is_fiction} -> genre_is_fiction
      _ -> false
    end
    
    changeset = Admin.change_book(%Book{
      author_id: author_id,
      genre_id: author.genre_id,
      is_fiction: is_fiction,
    })
    render(conn, "new.html", [changeset: changeset] ++ fields)
  end

  def new(conn, _params) do
    genre = case Admin.get_recent_popular_genre() do
      nil -> %Admin.Genre{id: nil, is_fiction: nil}
      genre -> genre
    end
    changeset = Admin.change_book(%Book{
      genre_id: genre.id,
      is_fiction: genre.is_fiction
    })
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create(conn, %{"book" => book_params}) do
    case Admin.create_book(book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    book = Admin.get_book!(id)
    changeset_is_active = book |> Admin.change_book |> Admin.change_book_is_active(!book.is_active)
    changeset_on_bookshelf = book |> Admin.change_book |> Admin.change_book_on_bookshelf(!book.on_bookshelf)
    render(conn, "show.html", book: book, changeset_is_active: changeset_is_active, changeset_on_bookshelf: changeset_on_bookshelf)
  end

  def edit(conn, %{"id" => id}) do
    book = Admin.get_book!(id)
    changeset = Admin.change_book(book)
    render(conn, "edit.html", [book: book, changeset: changeset] ++ related_fields())
  end

  def duplicate(conn, %{"id" => id}) do
    book = Admin.get_book!(id)
    changeset = Admin.change_book(%Book{}) |> Admin.duplicate_book(book)
    render(conn, "new.html", [book: book, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Admin.get_book!(id)

    case Admin.update_book(book, book_params) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [book: book, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Admin.get_book!(id)
    item_name = BooklistWeb.BookView.to_s(book)
    {:ok, _book} = Admin.delete_book(book)

    conn
    |> put_flash(:info, item_name <> " deleted.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end
