defmodule SerenWeb.TrackController do
  use SerenWeb, :controller

  alias Seren.Player
  alias Seren.Player.Track

  action_fallback SerenWeb.FallbackController

  def index_page(conn, tracks) do
    render(conn, "index.json", tracks: tracks)
  end

  def index(conn, %{"limit" => limit, "offset" => offset}) do
    tracks = Player.list_tracks(limit, offset)
    index_page(conn, tracks)
  end

  def index(conn, %{"limit" => limit}) do
    tracks = Player.list_tracks(limit)
    index_page(conn, tracks)
  end

  def index(conn, _params) do
    tracks = Player.list_tracks()
    index_page(conn, tracks)
  end

  def create(conn, %{"track" => track_params}) do
    with {:ok, %Track{} = track} <- Player.create_track(track_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", track_path(conn, :show, track))
      |> render("show.json", track: track)
    end
  end

  def show(conn, %{"id" => id}) do
    track = Player.get_track!(id)
    render(conn, "show.json", track: track)
  end

  def update(conn, %{"id" => id, "track" => track_params}) do
    track = Player.get_track!(id)

    with {:ok, %Track{} = track} <- Player.update_track(track, track_params) do
      render(conn, "show.json", track: track)
    end
  end

  def delete(conn, %{"id" => id}) do
    track = Player.get_track!(id)
    with {:ok, %Track{}} <- Player.delete_track(track) do
      send_resp(conn, :no_content, "")
    end
  end
end
