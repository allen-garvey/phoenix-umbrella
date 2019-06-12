defmodule SerenWeb.TrackControllerTest do
  use SerenWeb.ConnCase

  alias Seren.Player
  alias Seren.Player.Track

  @create_attrs %{album_artist: "some album_artist", album_disc_count: 42, album_disc_number: 42, album_title: "some album_title", album_track_count: 42, artist: "some artist", artwork_count: 42, bit_rate: 42, composer: "some composer", date_added: "2010-04-17 14:00:00.000000Z", date_modified: "2010-04-17 14:00:00.000000Z", file_path: "some file_path", file_size: 42, file_type: "some file_type", genre: "some genre", itunes_id: 42, length: 42, play_count: 42, play_date: "2010-04-17 14:00:00.000000Z", relase_year: 42, sample_rate: 42, title: "some title", track_number: 42}
  @update_attrs %{album_artist: "some updated album_artist", album_disc_count: 43, album_disc_number: 43, album_title: "some updated album_title", album_track_count: 43, artist: "some updated artist", artwork_count: 43, bit_rate: 43, composer: "some updated composer", date_added: "2011-05-18 15:01:01.000000Z", date_modified: "2011-05-18 15:01:01.000000Z", file_path: "some updated file_path", file_size: 43, file_type: "some updated file_type", genre: "some updated genre", itunes_id: 43, length: 43, play_count: 43, play_date: "2011-05-18 15:01:01.000000Z", relase_year: 43, sample_rate: 43, title: "some updated title", track_number: 43}
  @invalid_attrs %{album_artist: nil, album_disc_count: nil, album_disc_number: nil, album_title: nil, album_track_count: nil, artist: nil, artwork_count: nil, bit_rate: nil, composer: nil, date_added: nil, date_modified: nil, file_path: nil, file_size: nil, file_type: nil, genre: nil, itunes_id: nil, length: nil, play_count: nil, play_date: nil, relase_year: nil, sample_rate: nil, title: nil, track_number: nil}

  def fixture(:track) do
    {:ok, track} = Player.create_track(@create_attrs)
    track
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tracks", %{conn: conn} do
      conn = get conn, track_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create track" do
    test "renders track when data is valid", %{conn: conn} do
      conn = post conn, track_path(conn, :create), track: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, track_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "album_artist" => "some album_artist",
        "album_disc_count" => 42,
        "album_disc_number" => 42,
        "album_title" => "some album_title",
        "album_track_count" => 42,
        "artist" => "some artist",
        "artwork_count" => 42,
        "bit_rate" => 42,
        "composer" => "some composer",
        "date_added" => "2010-04-17 14:00:00.000000Z",
        "date_modified" => "2010-04-17 14:00:00.000000Z",
        "file_path" => "some file_path",
        "file_size" => 42,
        "file_type" => "some file_type",
        "genre" => "some genre",
        "itunes_id" => 42,
        "length" => 42,
        "play_count" => 42,
        "play_date" => "2010-04-17 14:00:00.000000Z",
        "relase_year" => 42,
        "sample_rate" => 42,
        "title" => "some title",
        "track_number" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, track_path(conn, :create), track: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update track" do
    setup [:create_track]

    test "renders track when data is valid", %{conn: conn, track: %Track{id: id} = track} do
      conn = put conn, track_path(conn, :update, track), track: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, track_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "album_artist" => "some updated album_artist",
        "album_disc_count" => 43,
        "album_disc_number" => 43,
        "album_title" => "some updated album_title",
        "album_track_count" => 43,
        "artist" => "some updated artist",
        "artwork_count" => 43,
        "bit_rate" => 43,
        "composer" => "some updated composer",
        "date_added" => "2011-05-18 15:01:01.000000Z",
        "date_modified" => "2011-05-18 15:01:01.000000Z",
        "file_path" => "some updated file_path",
        "file_size" => 43,
        "file_type" => "some updated file_type",
        "genre" => "some updated genre",
        "itunes_id" => 43,
        "length" => 43,
        "play_count" => 43,
        "play_date" => "2011-05-18 15:01:01.000000Z",
        "relase_year" => 43,
        "sample_rate" => 43,
        "title" => "some updated title",
        "track_number" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, track: track} do
      conn = put conn, track_path(conn, :update, track), track: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete track" do
    setup [:create_track]

    test "deletes chosen track", %{conn: conn, track: track} do
      conn = delete conn, track_path(conn, :delete, track)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, track_path(conn, :show, track)
      end
    end
  end

  defp create_track(_) do
    track = fixture(:track)
    {:ok, track: track}
  end
end
