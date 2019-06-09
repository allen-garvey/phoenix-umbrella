defmodule MovielistWeb.GenreController do
  use MovielistWeb, :controller

  alias Movielist.Admin
  alias Movielist.Reports
  alias Movielist.Admin.Genre

  def index(conn, _params) do
    genres = Admin.list_genres()
    render(conn, "index.html", genres: genres, page_atom: :genres_index)
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
    movie_stats = Reports.movie_stats_for_genre(id)
    rating_stats = Reports.rating_stats_for_genre(id)
    render(conn, "show.html", genre: genre, 
                              require_modal: true,
                              movie_count: movie_stats[:movie_count], 
                              average_pre_rating: movie_stats[:average_pre_rating],
                              rating_count: rating_stats[:rating_count],
                              average_score: rating_stats[:average_score]
                              )
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
    item_name = MovielistWeb.GenreView.to_s(genre)
    {:ok, _genre} = Admin.delete_genre(genre)

    conn
    |> put_flash(:info, "#{item_name} deleted successfully.")
    |> redirect(to: Routes.genre_path(conn, :index))
  end
end
