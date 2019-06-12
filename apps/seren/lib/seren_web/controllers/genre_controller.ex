defmodule SerenWeb.GenreController do
  use SerenWeb, :controller

  alias Seren.Player
  alias Seren.Player.Genre

  action_fallback SerenWeb.FallbackController

  def index(conn, _params) do
    genres = Player.list_genres()
    render(conn, "index.json", genres: genres)
  end

  def tracks_for(conn, %{"id" => id}) do
    tracks = Player.tracks_for_genre(id)
    conn
      |> put_view(SerenWeb.TrackView)
      |> SerenWeb.TrackController.index_page(tracks)
  end

  def create(conn, %{"genre" => genre_params}) do
    with {:ok, %Genre{} = genre} <- Player.create_genre(genre_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", genre_path(conn, :show, genre))
      |> render("show.json", genre: genre)
    end
  end

  def show(conn, %{"id" => id}) do
    genre = Player.get_genre!(id)
    render(conn, "show.json", genre: genre)
  end

  def update(conn, %{"id" => id, "genre" => genre_params}) do
    genre = Player.get_genre!(id)

    with {:ok, %Genre{} = genre} <- Player.update_genre(genre, genre_params) do
      render(conn, "show.json", genre: genre)
    end
  end

  def delete(conn, %{"id" => id}) do
    genre = Player.get_genre!(id)
    with {:ok, %Genre{}} <- Player.delete_genre(genre) do
      send_resp(conn, :no_content, "")
    end
  end
end
