defmodule Movielist.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Movielist.Admin.Genre
  alias Movielist.Admin.Movie
  alias Movielist.Admin.Rating
  alias Movielist.Admin.Streamer

  #Estimated time in days between movies theater release and home release
  @movie_home_release_estimated_lead_time 90

  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    Repo.all(from(Genre, order_by: :name))
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

  @doc """
  Gets a single genre id or nil.

  Looks at last 10 movies
  and finds the most popular genre id.
  """
  def get_recent_popular_genre_id() do
    movie_query = from(
      Movie,
      order_by: [desc: :inserted_at, desc: :id],
      limit: 10
    )
    
    from(
      movie in subquery(movie_query),
      group_by: [movie.genre_id],
      order_by: [desc: count(movie.genre_id)],
      select: movie.genre_id,
      limit: 1
    )
    |> Repo.one
  end

  @doc """
  Returns the list of movies.

  ## Examples

      iex> list_movies()
      [%Movie{}, ...]

  """
  def list_movies do
    Repo.all(from(m in Movie, join: genre in assoc(m, :genre), preload: [genre: genre], order_by: [:sort_title, :id]))
  end

  @doc """
  Base query for list of active movies
  """
  def list_movies_active_base_query do
    from(
          m in Movie,
          join: genre in assoc(m, :genre),
          left_join: streamer in assoc(m, :streamer),
          where: m.is_active == true,
          preload: [genre: genre, streamer: streamer],
          select: %{
                    movie: m,
                    release_status: fragment("CASE WHEN ? <= CURRENT_DATE THEN 1 WHEN ? <= CURRENT_DATE THEN 2 ELSE 3 END AS release_status", m.home_release_date, m.theater_release_date),
                    #can't use release_status in release_date without subquery, and can't have nested maps or structs in ecto subqueries, so easiest just to repeat release_status logic here
                    release_date: fragment("CASE WHEN ? <= CURRENT_DATE THEN NULL WHEN ? <= CURRENT_DATE THEN COALESCE(?, ? + INTERVAL '? DAY') ELSE COALESCE(?, ?) END AS release_date", m.home_release_date, m.theater_release_date, m.home_release_date, m.theater_release_date, @movie_home_release_estimated_lead_time, m.theater_release_date, m.home_release_date)
                    })
  end

  @doc """
  Manually preloads virtual release_date and release status fields for movies
  """
  def preload_movie_virtual_fields(results) do
    results
    |> Enum.map(fn %{movie: movie, release_status: release_status, release_date: release_date} ->
      %Movie{movie | release_date: release_date, release_status: release_status_atom(release_status)}
    end)
  end

  @doc """
  Turns movie release status int from database to atom
  """
  def release_status_atom(release_status) when is_integer(release_status) do
    case release_status do
      1 -> :home_released
      2 -> :theater_released
      _ -> :unreleased
    end
  end

  @doc """
  Returns the list of active along with calculated release dates movies.
  """
  def list_movies_active do
    list_movies_active_base_query()
     |> order_by([m], [asc: fragment("release_status"), asc: fragment("release_date"), desc: :pre_rating, asc: :sort_title, asc: :id])
     |> Repo.all
     |> preload_movie_virtual_fields
  end

  @doc """
  Similar to list_movies_active, but returns only movies that have been released and has slightly different sorting
  """
  def list_movies_suggestions do
    list_movies_active_base_query()
     |> where([m], fragment("(? <= CURRENT_DATE OR ? <= CURRENT_DATE)", m.home_release_date, m.theater_release_date))
     |> order_by([m], [asc: fragment("release_status"), desc: m.pre_rating, desc: fragment("release_date"), asc: :sort_title, asc: :id])
     |> Repo.all
     |> preload_movie_virtual_fields
  end

  @doc """
  Gets a single movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(123)
      %Movie{}

      iex> get_movie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(id) do
    from(
      movie in Movie,
      join: genre in assoc(movie, :genre),
      left_join: streamer in assoc(movie, :streamer),
      left_join: rating in assoc(movie, :ratings),
      where: movie.id == ^id,
      preload: [genre: genre, ratings: rating, streamer: streamer],
      order_by: [desc: rating.date_scored, desc: rating.id]
    )
    |> Repo.one!
  end

  @doc """
  Creates a movie.

  ## Examples

      iex> create_movie(%{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a movie.

  ## Examples

      iex> update_movie(movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_movie(%Movie{} = movie, attrs) do
    movie
    |> Movie.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Movie.

  ## Examples

      iex> delete_movie(movie)
      {:ok, %Movie{}}

      iex> delete_movie(movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = movie) do
    Repo.delete(movie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movie changes.

  ## Examples

      iex> change_movie(movie)
      %Ecto.Changeset{source: %Movie{}}

  """
  def change_movie(%Movie{} = movie) do
    Movie.changeset(movie, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` with is_active property changed
  """
  def change_movie_is_active(movie_changeset, is_active) when is_boolean(is_active) do
    movie_changeset
    |> Ecto.Changeset.put_change(:is_active, is_active)
  end

  @doc """
  Base query to get list of ratings.
  Note also used in reports context
  """
  def list_ratings_base_query do
    from(r in Rating, join: movie in assoc(r, :movie), preload: [movie: movie])
  end
  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings()
      [%Rating{}, ...]

  """
  def list_ratings do
    list_ratings_base_query()
    |> order_by(desc: :id)
    |> Repo.all
  end

  @doc """
  Returns the list of sorted by score ratings.
  """
  def list_ratings_by_score do
    list_ratings_base_query()
    |> order_by(desc: :score, desc: :id)
    |> Repo.all
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(123)
      %Rating{}

      iex> get_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(id) do
    from(r in Rating, join: movie in assoc(r, :movie), where: r.id == ^id, preload: [movie: movie])
    |> Repo.one!
  end

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rating(attrs \\ %{}) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Rating.

  ## Examples

      iex> delete_rating(rating)
      {:ok, %Rating{}}

      iex> delete_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(rating)
      %Ecto.Changeset{source: %Rating{}}

  """
  def change_rating(%Rating{} = rating) do
    Rating.changeset(rating, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.
  Initialized with given movie_id
  """
  def change_rating_with_movie(%Rating{} = rating, movie_id) do
    Rating.changeset(rating, %{})
      |> Ecto.Changeset.put_change(:movie_id, movie_id)
  end

  @doc """
  Returns the list of streamers.

  ## Examples

      iex> list_streamers()
      [%Streamer{}, ...]

  """
  def list_streamers do
    Repo.all(from(Streamer, order_by: :name))
  end

  @doc """
  Gets a single streamer.

  Raises `Ecto.NoResultsError` if the Streamer does not exist.

  ## Examples

      iex> get_streamer!(123)
      %Streamer{}

      iex> get_streamer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_streamer!(id) do
    movie_query = from(
      movie in Movie,
      where: movie.is_active == true,
      order_by: [movie.sort_title]
    )

    from(
      streamer in Streamer,
      where: streamer.id == ^id,
      preload: [movies: ^movie_query]
    )
    |> Repo.one!
  end

  @doc """
  Creates a streamer.

  ## Examples

      iex> create_streamer(%{field: value})
      {:ok, %Streamer{}}

      iex> create_streamer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_streamer(attrs \\ %{}) do
    %Streamer{}
    |> Streamer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a streamer.

  ## Examples

      iex> update_streamer(streamer, %{field: new_value})
      {:ok, %Streamer{}}

      iex> update_streamer(streamer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_streamer(%Streamer{} = streamer, attrs) do
    streamer
    |> Streamer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a streamer.

  ## Examples

      iex> delete_streamer(streamer)
      {:ok, %Streamer{}}

      iex> delete_streamer(streamer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_streamer(%Streamer{} = streamer) do
    Repo.delete(streamer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking streamer changes.

  ## Examples

      iex> change_streamer(streamer)
      %Ecto.Changeset{data: %Streamer{}}

  """
  def change_streamer(%Streamer{} = streamer, attrs \\ %{}) do
    Streamer.changeset(streamer, attrs)
  end
end
