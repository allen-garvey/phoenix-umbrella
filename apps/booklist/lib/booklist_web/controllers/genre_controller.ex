defmodule BooklistWeb.GenreController do
  use BooklistWeb, :controller

  alias Booklist.Admin
  alias Booklist.Admin.Genre

  def index(conn, _params) do
    genres = Admin.list_genres()
    render(conn, "index.html", genres: genres)
  end

  def new(conn, _params) do
    changeset = Admin.change_genre(%Genre{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"genre" => genre_params}) do
    case Admin.create_genre(genre_params) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre created successfully.")
        |> redirect(to: Routes.genre_path(conn, :show, genre))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    genre = Admin.get_genre!(id)
    ratings = Admin.list_ratings_for_genre(id)
    render(conn, "show.html", genre: genre, ratings: ratings)
  end

  def edit(conn, %{"id" => id}) do
    genre = Admin.get_genre!(id)
    changeset = Admin.change_genre(genre)
    render(conn, "edit.html", genre: genre, changeset: changeset)
  end

  def update(conn, %{"id" => id, "genre" => genre_params}) do
    genre = Admin.get_genre!(id)

    case Admin.update_genre(genre, genre_params) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre updated successfully.")
        |> redirect(to: Routes.genre_path(conn, :show, genre))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", genre: genre, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    genre = Admin.get_genre!(id)
    item_name = BooklistWeb.GenreView.to_s(genre)
    {:ok, _genre} = Admin.delete_genre(genre)

    conn
    |> put_flash(:info, item_name <> " deleted.")
    |> redirect(to: Routes.genre_path(conn, :index))
  end
end
