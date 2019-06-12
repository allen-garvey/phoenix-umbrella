defmodule SerenWeb.ArtistController do
  use SerenWeb, :controller

  alias Seren.Player
  alias Seren.Player.Artist

  action_fallback SerenWeb.FallbackController

  def index(conn, _params) do
    artists = Player.list_artists()
    render(conn, "index.json", artists: artists)
  end

  def tracks_for(conn, %{"id" => id}) do
    tracks = Player.tracks_for_artist(id)
    conn
      |> put_view(SerenWeb.TrackView)
      |> SerenWeb.TrackController.index_page(tracks)
  end

  def create(conn, %{"artist" => artist_params}) do
    with {:ok, %Artist{} = artist} <- Player.create_artist(artist_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", artist_path(conn, :show, artist))
      |> render("show.json", artist: artist)
    end
  end

  def show(conn, %{"id" => id}) do
    artist = Player.get_artist!(id)
    render(conn, "show.json", artist: artist)
  end

  def update(conn, %{"id" => id, "artist" => artist_params}) do
    artist = Player.get_artist!(id)

    with {:ok, %Artist{} = artist} <- Player.update_artist(artist, artist_params) do
      render(conn, "show.json", artist: artist)
    end
  end

  def delete(conn, %{"id" => id}) do
    artist = Player.get_artist!(id)
    with {:ok, %Artist{}} <- Player.delete_artist(artist) do
      send_resp(conn, :no_content, "")
    end
  end
end
