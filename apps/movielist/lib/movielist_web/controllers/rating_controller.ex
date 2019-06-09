defmodule MovielistWeb.RatingController do
  use MovielistWeb, :controller

  alias Movielist.Admin
  alias Movielist.Admin.Rating

  def related_fields() do
    [
      movies: Admin.list_movies() |> MovielistWeb.MovieView.map_for_form,
    ]
  end

  def index(conn, %{"sort" => "score"}) do
    ratings = Admin.list_ratings_by_score()
    render(conn, "index.html", ratings: ratings, page_atom: :ratings_index)
  end

  def index(conn, _params) do
    ratings = Admin.list_ratings()
    render(conn, "index.html", ratings: ratings, page_atom: :ratings_index)
  end

  def new(conn, %{"movie_id" => movie_id}) do
    changeset = Admin.change_rating_with_movie(%Rating{}, movie_id)
    render(conn, "new.html", [changeset: changeset, referrer: "movie"] ++ related_fields())
  end

  def new(conn, _params) do
    changeset = Admin.change_rating(%Rating{})
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create(conn, %{"rating" => rating_params, "referrer" => "movie"}) do
    create_action(conn, rating_params, fn (conn, rating) -> Routes.movie_path(conn, :show, rating.movie_id) end, "movie")
  end

  def create(conn, %{"rating" => rating_params}) do
    create_action(conn, rating_params, fn (conn, rating) -> Routes.rating_path(conn, :show, rating) end)
  end

  def create_action(conn, rating_params, success_redirect_callback, referrer \\ nil) when is_function(success_redirect_callback, 2) do
    case Admin.create_rating(rating_params) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating created successfully.")
        |> redirect(to: success_redirect_callback.(conn, rating))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset, referrer: referrer] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    rating = Admin.get_rating!(id)
    render(conn, "show.html", rating: rating, require_modal: true)
  end

  def edit(conn, %{"id" => id}) do
    rating = Admin.get_rating!(id)
    changeset = Admin.change_rating(rating)
    render(conn, "edit.html", [rating: rating, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "rating" => rating_params}) do
    rating = Admin.get_rating!(id)

    case Admin.update_rating(rating, rating_params) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating updated successfully.")
        |> redirect(to: Routes.rating_path(conn, :show, rating))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [rating: rating, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    rating = Admin.get_rating!(id)
    {:ok, _rating} = Admin.delete_rating(rating)

    conn
    |> put_flash(:info, "Rating deleted successfully.")
    |> redirect(to: Routes.rating_path(conn, :index))
  end
end
