defmodule MovielistWeb.MovieController do
  use MovielistWeb, :controller

  alias Movielist.Admin
  alias Movielist.Admin.Movie
  alias MovielistWeb.MovieView

  def related_fields() do
    [
      genres: Admin.list_genres() |> MovielistWeb.GenreView.map_for_form(),
      streamers: [nil | Admin.list_streamers() |> MovielistWeb.StreamerView.map_for_form()]
    ]
  end

  def index(conn, _params) do
    movies = Admin.list_movies()
    render(conn, "index.html", movies: movies, page_atom: :movies_index)
  end

  def index_active(conn, %{"sort" => sort}) do
    index_active_page(conn, sort)
  end

  def index_active(conn, _params) do
    index_active_page(conn, nil)
  end

  defp index_active_page(conn, sort) do
    movies = Admin.list_movies_active(sort)

    render(conn, "index_active.html",
      movies: movies,
      page_route: :index_active,
      page_atom: :movies_index
    )
  end

  def index_suggestions(conn, %{"sort" => sort}) do
    suggestions_page(conn, sort)
  end

  def index_suggestions(conn, _params) do
    suggestions_page(conn, nil)
  end

  defp suggestions_page(conn, sort) do
    movies = Admin.list_movies_suggestions(sort)

    render(conn, "index_active.html",
      movies: movies,
      page_route: :index_suggestions,
      page_atom: :movies_suggestions
    )
  end

  def new(conn, _params) do
    changeset =
      Admin.change_movie(%Movie{
        genre_id: Admin.get_recent_popular_genre_id()
      })

    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create(conn, %{"movie" => movie_params}) do
    case Admin.create_movie(movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, MovieView.movie_created_flash(conn, movie))
        |> redirect(to: Routes.movie_path(conn, :index_active))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    movie = Admin.get_movie!(id)

    changeset_is_active =
      movie |> Admin.change_movie() |> Admin.change_movie_is_active(!movie.is_active)

    render(conn, "show.html",
      movie: movie,
      changeset_is_active: changeset_is_active,
      require_modal: true
    )
  end

  def edit(conn, %{"id" => id}) do
    movie = Admin.get_movie!(id)
    changeset = Admin.change_movie(movie)
    render(conn, "edit.html", [movie: movie, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "movie" => movie_params}) do
    movie = Admin.get_movie!(id)

    case Admin.update_movie(movie, movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, "Movie updated successfully.")
        |> redirect(to: Routes.movie_path(conn, :show, movie))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [movie: movie, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    movie = Admin.get_movie!(id)
    item_name = MovielistWeb.MovieView.to_s(movie)
    {:ok, _movie} = Admin.delete_movie(movie)

    conn
    |> put_flash(:info, "#{item_name} deleted successfully.")
    |> redirect(to: Routes.movie_path(conn, :index))
  end
end
