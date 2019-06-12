defmodule Seren.PlayerTest do
  use Seren.DataCase

  alias Seren.Player

  describe "tracks" do
    alias Seren.Player.Track

    @valid_attrs %{album_artist: "some album_artist", album_disc_count: 42, album_disc_number: 42, album_title: "some album_title", album_track_count: 42, artist: "some artist", artwork_count: 42, bit_rate: 42, composer: "some composer", date_added: "2010-04-17 14:00:00.000000Z", date_modified: "2010-04-17 14:00:00.000000Z", file_path: "some file_path", file_size: 42, file_type: "some file_type", genre: "some genre", itunes_id: 42, length: 42, play_count: 42, play_date: "2010-04-17 14:00:00.000000Z", relase_year: 42, sample_rate: 42, title: "some title", track_number: 42}
    @update_attrs %{album_artist: "some updated album_artist", album_disc_count: 43, album_disc_number: 43, album_title: "some updated album_title", album_track_count: 43, artist: "some updated artist", artwork_count: 43, bit_rate: 43, composer: "some updated composer", date_added: "2011-05-18 15:01:01.000000Z", date_modified: "2011-05-18 15:01:01.000000Z", file_path: "some updated file_path", file_size: 43, file_type: "some updated file_type", genre: "some updated genre", itunes_id: 43, length: 43, play_count: 43, play_date: "2011-05-18 15:01:01.000000Z", relase_year: 43, sample_rate: 43, title: "some updated title", track_number: 43}
    @invalid_attrs %{album_artist: nil, album_disc_count: nil, album_disc_number: nil, album_title: nil, album_track_count: nil, artist: nil, artwork_count: nil, bit_rate: nil, composer: nil, date_added: nil, date_modified: nil, file_path: nil, file_size: nil, file_type: nil, genre: nil, itunes_id: nil, length: nil, play_count: nil, play_date: nil, relase_year: nil, sample_rate: nil, title: nil, track_number: nil}

    def track_fixture(attrs \\ %{}) do
      {:ok, track} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_track()

      track
    end

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Player.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Player.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      assert {:ok, %Track{} = track} = Player.create_track(@valid_attrs)
      assert track.album_artist == "some album_artist"
      assert track.album_disc_count == 42
      assert track.album_disc_number == 42
      assert track.album_title == "some album_title"
      assert track.album_track_count == 42
      assert track.artist == "some artist"
      assert track.artwork_count == 42
      assert track.bit_rate == 42
      assert track.composer == "some composer"
      assert track.date_added == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert track.date_modified == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert track.file_path == "some file_path"
      assert track.file_size == 42
      assert track.file_type == "some file_type"
      assert track.genre == "some genre"
      assert track.itunes_id == 42
      assert track.length == 42
      assert track.play_count == 42
      assert track.play_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert track.relase_year == 42
      assert track.sample_rate == 42
      assert track.title == "some title"
      assert track.track_number == 42
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()
      assert {:ok, track} = Player.update_track(track, @update_attrs)
      assert %Track{} = track
      assert track.album_artist == "some updated album_artist"
      assert track.album_disc_count == 43
      assert track.album_disc_number == 43
      assert track.album_title == "some updated album_title"
      assert track.album_track_count == 43
      assert track.artist == "some updated artist"
      assert track.artwork_count == 43
      assert track.bit_rate == 43
      assert track.composer == "some updated composer"
      assert track.date_added == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert track.date_modified == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert track.file_path == "some updated file_path"
      assert track.file_size == 43
      assert track.file_type == "some updated file_type"
      assert track.genre == "some updated genre"
      assert track.itunes_id == 43
      assert track.length == 43
      assert track.play_count == 43
      assert track.play_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert track.relase_year == 43
      assert track.sample_rate == 43
      assert track.title == "some updated title"
      assert track.track_number == 43
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_track(track, @invalid_attrs)
      assert track == Player.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Player.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Player.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Player.change_track(track)
    end
  end

  describe "artists" do
    alias Seren.Player.Artist

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def artist_fixture(attrs \\ %{}) do
      {:ok, artist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_artist()

      artist
    end

    test "list_artists/0 returns all artists" do
      artist = artist_fixture()
      assert Player.list_artists() == [artist]
    end

    test "get_artist!/1 returns the artist with given id" do
      artist = artist_fixture()
      assert Player.get_artist!(artist.id) == artist
    end

    test "create_artist/1 with valid data creates a artist" do
      assert {:ok, %Artist{} = artist} = Player.create_artist(@valid_attrs)
      assert artist.name == "some name"
    end

    test "create_artist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_artist(@invalid_attrs)
    end

    test "update_artist/2 with valid data updates the artist" do
      artist = artist_fixture()
      assert {:ok, artist} = Player.update_artist(artist, @update_attrs)
      assert %Artist{} = artist
      assert artist.name == "some updated name"
    end

    test "update_artist/2 with invalid data returns error changeset" do
      artist = artist_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_artist(artist, @invalid_attrs)
      assert artist == Player.get_artist!(artist.id)
    end

    test "delete_artist/1 deletes the artist" do
      artist = artist_fixture()
      assert {:ok, %Artist{}} = Player.delete_artist(artist)
      assert_raise Ecto.NoResultsError, fn -> Player.get_artist!(artist.id) end
    end

    test "change_artist/1 returns a artist changeset" do
      artist = artist_fixture()
      assert %Ecto.Changeset{} = Player.change_artist(artist)
    end
  end

  describe "genres" do
    alias Seren.Player.Genre

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def genre_fixture(attrs \\ %{}) do
      {:ok, genre} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_genre()

      genre
    end

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert Player.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert Player.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = Player.create_genre(@valid_attrs)
      assert genre.name == "some name"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_genre(@invalid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, genre} = Player.update_genre(genre, @update_attrs)
      assert %Genre{} = genre
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_genre(genre, @invalid_attrs)
      assert genre == Player.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = Player.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> Player.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = Player.change_genre(genre)
    end
  end

  describe "composers" do
    alias Seren.Player.Composer

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def composer_fixture(attrs \\ %{}) do
      {:ok, composer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_composer()

      composer
    end

    test "list_composers/0 returns all composers" do
      composer = composer_fixture()
      assert Player.list_composers() == [composer]
    end

    test "get_composer!/1 returns the composer with given id" do
      composer = composer_fixture()
      assert Player.get_composer!(composer.id) == composer
    end

    test "create_composer/1 with valid data creates a composer" do
      assert {:ok, %Composer{} = composer} = Player.create_composer(@valid_attrs)
      assert composer.name == "some name"
    end

    test "create_composer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_composer(@invalid_attrs)
    end

    test "update_composer/2 with valid data updates the composer" do
      composer = composer_fixture()
      assert {:ok, composer} = Player.update_composer(composer, @update_attrs)
      assert %Composer{} = composer
      assert composer.name == "some updated name"
    end

    test "update_composer/2 with invalid data returns error changeset" do
      composer = composer_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_composer(composer, @invalid_attrs)
      assert composer == Player.get_composer!(composer.id)
    end

    test "delete_composer/1 deletes the composer" do
      composer = composer_fixture()
      assert {:ok, %Composer{}} = Player.delete_composer(composer)
      assert_raise Ecto.NoResultsError, fn -> Player.get_composer!(composer.id) end
    end

    test "change_composer/1 returns a composer changeset" do
      composer = composer_fixture()
      assert %Ecto.Changeset{} = Player.change_composer(composer)
    end
  end

  describe "file_types" do
    alias Seren.Player.FileType

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def file_type_fixture(attrs \\ %{}) do
      {:ok, file_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_file_type()

      file_type
    end

    test "list_file_types/0 returns all file_types" do
      file_type = file_type_fixture()
      assert Player.list_file_types() == [file_type]
    end

    test "get_file_type!/1 returns the file_type with given id" do
      file_type = file_type_fixture()
      assert Player.get_file_type!(file_type.id) == file_type
    end

    test "create_file_type/1 with valid data creates a file_type" do
      assert {:ok, %FileType{} = file_type} = Player.create_file_type(@valid_attrs)
      assert file_type.name == "some name"
    end

    test "create_file_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_file_type(@invalid_attrs)
    end

    test "update_file_type/2 with valid data updates the file_type" do
      file_type = file_type_fixture()
      assert {:ok, file_type} = Player.update_file_type(file_type, @update_attrs)
      assert %FileType{} = file_type
      assert file_type.name == "some updated name"
    end

    test "update_file_type/2 with invalid data returns error changeset" do
      file_type = file_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_file_type(file_type, @invalid_attrs)
      assert file_type == Player.get_file_type!(file_type.id)
    end

    test "delete_file_type/1 deletes the file_type" do
      file_type = file_type_fixture()
      assert {:ok, %FileType{}} = Player.delete_file_type(file_type)
      assert_raise Ecto.NoResultsError, fn -> Player.get_file_type!(file_type.id) end
    end

    test "change_file_type/1 returns a file_type changeset" do
      file_type = file_type_fixture()
      assert %Ecto.Changeset{} = Player.change_file_type(file_type)
    end
  end

  describe "albums" do
    alias Seren.Player.Album

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def album_fixture(attrs \\ %{}) do
      {:ok, album} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Player.create_album()

      album
    end

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Player.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Player.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      assert {:ok, %Album{} = album} = Player.create_album(@valid_attrs)
      assert album.title == "some title"
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      assert {:ok, album} = Player.update_album(album, @update_attrs)
      assert %Album{} = album
      assert album.title == "some updated title"
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_album(album, @invalid_attrs)
      assert album == Player.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Player.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Player.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Player.change_album(album)
    end
  end
end
