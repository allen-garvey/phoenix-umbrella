defmodule Seren.Player do
  @moduledoc """
  The Player context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Seren.Player.Track

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """
  def list_tracks do
    Repo.all(Track)
  end

  def list_tracks(limit) do
    from(t in Track,
      join: artist in assoc(t, :artist),
      left_join: album in assoc(t, :album),
      limit: ^limit,
      order_by: [artist.name, album.title, :album_disc_number, :track_number, :title]
    )
    |> Repo.all()
  end

  def list_tracks(limit, offset) do
    from(t in Track,
      join: artist in assoc(t, :artist),
      left_join: album in assoc(t, :album),
      limit: ^limit,
      offset: ^offset,
      order_by: [artist.name, album.title, :album_disc_number, :track_number, :title]
    )
    |> Repo.all()
  end

  @doc """
  Returns list of tracks for various models
  """
  def tracks_for_artist(id) do
    from(t in Track,
      where: t.artist_id == ^id,
      left_join: album in assoc(t, :album),
      order_by: [album.title, :album_disc_number, :track_number, :title]
    )
    |> Repo.all()
  end

  def tracks_for_genre(id) do
    from(t in Track,
      join: artist in assoc(t, :artist),
      left_join: album in assoc(t, :album),
      where: t.genre_id == ^id,
      order_by: [artist.name, album.title, :album_disc_number, :track_number, :title]
    )
    |> Repo.all()
  end

  def tracks_for_composer(id) do
    from(t in Track,
      join: artist in assoc(t, :artist),
      left_join: album in assoc(t, :album),
      where: t.composer_id == ^id,
      order_by: [album.title, :album_disc_number, :track_number, artist.name, :title]
    )
    |> Repo.all()
  end

  def tracks_for_album(id) do
    from(t in Track,
      join: artist in assoc(t, :artist),
      where: t.album_id == ^id,
      order_by: [:album_disc_number, :track_number, artist.name, :title]
    )
    |> Repo.all()
  end

  @doc """
  Returns list of tracks for search query
  """
  def tracks_for_search(query, limit) do
    like_query = "%#{String.replace(query, "%", "\\%") |> String.replace("_", "\\_")}%"

    from(t in Track,
      join: artist in assoc(t, :artist),
      left_join: album in assoc(t, :album),
      left_join: c in assoc(t, :composer),
      where:
        ilike(t.title, ^like_query) or
          ilike(artist.name, ^like_query) or
          ilike(album.title, ^like_query) or
          ilike(c.name, ^like_query),
      order_by: [artist.name, album.title, :album_disc_number, :track_number, :title],
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc """
  Gets a single track.

  Raises `Ecto.NoResultsError` if the Track does not exist.

  ## Examples

      iex> get_track!(123)
      %Track{}

      iex> get_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track!(id), do: Repo.get!(Track, id)

  @doc """
  Creates a track.

  ## Examples

      iex> create_track(%{field: value})
      {:ok, %Track{}}

      iex> create_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Track.

  ## Examples

      iex> delete_track(track)
      {:ok, %Track{}}

      iex> delete_track(track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.

  ## Examples

      iex> change_track(track)
      %Ecto.Changeset{source: %Track{}}

  """
  def change_track(%Track{} = track) do
    Track.changeset(track, %{})
  end

  alias Seren.Player.Artist

  @doc """
  Returns the list of artists.

  ## Examples

      iex> list_artists()
      [%Artist{}, ...]

  """
  def list_artists do
    from(Artist, order_by: :name)
    |> Repo.all()
  end

  @doc """
  Gets a single artist.

  Raises `Ecto.NoResultsError` if the Artist does not exist.

  ## Examples

      iex> get_artist!(123)
      %Artist{}

      iex> get_artist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_artist!(id) do
    Repo.get!(Artist, id)
  end

  @doc """
  Creates a artist.

  ## Examples

      iex> create_artist(%{field: value})
      {:ok, %Artist{}}

      iex> create_artist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a artist.

  ## Examples

      iex> update_artist(artist, %{field: new_value})
      {:ok, %Artist{}}

      iex> update_artist(artist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Artist.

  ## Examples

      iex> delete_artist(artist)
      {:ok, %Artist{}}

      iex> delete_artist(artist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking artist changes.

  ## Examples

      iex> change_artist(artist)
      %Ecto.Changeset{source: %Artist{}}

  """
  def change_artist(%Artist{} = artist) do
    Artist.changeset(artist, %{})
  end

  alias Seren.Player.Genre

  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    from(Genre, order_by: :name)
    |> Repo.all()
  end

  @doc """
  Gets a single genre.

  Raises `Ecto.NoResultsError` if the Genre does not exist.

  ## Examples

      iex> get_genre!(123)
      %Genre{}

      iex> get_genre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_genre!(id), do: Repo.get!(Genre, id)

  @doc """
  Creates a genre.

  ## Examples

      iex> create_genre(%{field: value})
      {:ok, %Genre{}}

      iex> create_genre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a genre.

  ## Examples

      iex> update_genre(genre, %{field: new_value})
      {:ok, %Genre{}}

      iex> update_genre(genre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Genre.

  ## Examples

      iex> delete_genre(genre)
      {:ok, %Genre{}}

      iex> delete_genre(genre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_genre(%Genre{} = genre) do
    Repo.delete(genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre changes.

  ## Examples

      iex> change_genre(genre)
      %Ecto.Changeset{source: %Genre{}}

  """
  def change_genre(%Genre{} = genre) do
    Genre.changeset(genre, %{})
  end

  alias Seren.Player.Composer

  @doc """
  Returns the list of composers.

  ## Examples

      iex> list_composers()
      [%Composer{}, ...]

  """
  def list_composers do
    from(Composer, order_by: :name)
    |> Repo.all()
  end

  @doc """
  Gets a single composer.

  Raises `Ecto.NoResultsError` if the Composer does not exist.

  ## Examples

      iex> get_composer!(123)
      %Composer{}

      iex> get_composer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_composer!(id), do: Repo.get!(Composer, id)

  @doc """
  Creates a composer.

  ## Examples

      iex> create_composer(%{field: value})
      {:ok, %Composer{}}

      iex> create_composer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_composer(attrs \\ %{}) do
    %Composer{}
    |> Composer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a composer.

  ## Examples

      iex> update_composer(composer, %{field: new_value})
      {:ok, %Composer{}}

      iex> update_composer(composer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_composer(%Composer{} = composer, attrs) do
    composer
    |> Composer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Composer.

  ## Examples

      iex> delete_composer(composer)
      {:ok, %Composer{}}

      iex> delete_composer(composer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_composer(%Composer{} = composer) do
    Repo.delete(composer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking composer changes.

  ## Examples

      iex> change_composer(composer)
      %Ecto.Changeset{source: %Composer{}}

  """
  def change_composer(%Composer{} = composer) do
    Composer.changeset(composer, %{})
  end

  alias Seren.Player.FileType

  @doc """
  Returns the list of file_types.

  ## Examples

      iex> list_file_types()
      [%FileType{}, ...]

  """
  def list_file_types do
    Repo.all(FileType)
  end

  @doc """
  Gets a single file_type.

  Raises `Ecto.NoResultsError` if the File type does not exist.

  ## Examples

      iex> get_file_type!(123)
      %FileType{}

      iex> get_file_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file_type!(id), do: Repo.get!(FileType, id)

  @doc """
  Creates a file_type.

  ## Examples

      iex> create_file_type(%{field: value})
      {:ok, %FileType{}}

      iex> create_file_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file_type(attrs \\ %{}) do
    %FileType{}
    |> FileType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file_type.

  ## Examples

      iex> update_file_type(file_type, %{field: new_value})
      {:ok, %FileType{}}

      iex> update_file_type(file_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file_type(%FileType{} = file_type, attrs) do
    file_type
    |> FileType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FileType.

  ## Examples

      iex> delete_file_type(file_type)
      {:ok, %FileType{}}

      iex> delete_file_type(file_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file_type(%FileType{} = file_type) do
    Repo.delete(file_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file_type changes.

  ## Examples

      iex> change_file_type(file_type)
      %Ecto.Changeset{source: %FileType{}}

  """
  def change_file_type(%FileType{} = file_type) do
    FileType.changeset(file_type, %{})
  end

  alias Seren.Player.Album

  @doc """
  Returns the list of albums.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_albums do
    Repo.all(Album)
  end

  @doc """
  Gets a single album.

  Raises `Ecto.NoResultsError` if the Album does not exist.

  ## Examples

      iex> get_album!(123)
      %Album{}

      iex> get_album!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album!(id), do: Repo.get!(Album, id)

  @doc """
  Creates a album.

  ## Examples

      iex> create_album(%{field: value})
      {:ok, %Album{}}

      iex> create_album(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a album.

  ## Examples

      iex> update_album(album, %{field: new_value})
      {:ok, %Album{}}

      iex> update_album(album, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Album.

  ## Examples

      iex> delete_album(album)
      {:ok, %Album{}}

      iex> delete_album(album)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album changes.

  ## Examples

      iex> change_album(album)
      %Ecto.Changeset{source: %Album{}}

  """
  def change_album(%Album{} = album) do
    Album.changeset(album, %{})
  end
end
