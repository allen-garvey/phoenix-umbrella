defmodule Booklist.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Grenadier.Repo

  alias Booklist.Admin.Rating
  alias Booklist.Admin.Genre
  alias Booklist.Admin.Author
  alias Booklist.Admin.Book

  def calculate_percent_of_ratings(total, ratings_count) do
    (total / max(ratings_count, 1) * 100) |> Float.round(2)
  end

  @doc """
  Gets all ratings for given year
  """
  def get_ratings(year) do
    from(
      r in Rating,
      join: book in assoc(r, :book),
      where: fragment("EXTRACT(year FROM ?)", r.date_scored) == ^year,
      order_by: [desc: r.score, desc: r.id],
      preload: [book: book]
    )
    |> Repo.all()
  end

  @doc """
  Gets list of years with number of books read for each year
  """
  def get_num_ratings_per_year() do
    from(
      r in Rating,
      order_by: [fragment("EXTRACT(year FROM ?)", r.date_scored)],
      group_by: [fragment("EXTRACT(year FROM ?)", r.date_scored)],
      # have to use type to cast as integer, otherwise returns decimal
      select: {type(fragment("EXTRACT(year FROM ?)", r.date_scored), :integer), count()}
    )
    |> Repo.all()
  end

  def calculate_rating_total(ratings) do
    Enum.reduce(ratings, 0, fn rating, total -> total + rating.score end)
  end

  def calculate_nonfiction_count(ratings) do
    Enum.count(ratings, fn rating -> rating.book.is_fiction == false end)
  end

  defp get_end_date(year, current_date) do
    case year == current_date.year do
      true -> current_date
      false -> Date.new!(year, 12, 31)
    end
    |> Date.beginning_of_week(:sunday)
  end

  def calculate_ratings_by_week(ratings, year, current_date) do
    start_date = Date.new!(year, 1, 1) |> Date.beginning_of_week(:sunday)
    end_date = get_end_date(year, current_date)

    weeks_count_map =
      ratings
      |> Enum.reduce(%{}, fn rating, map ->
        Map.update(
          map,
          Date.beginning_of_week(rating.date_scored, :sunday),
          1,
          &Common.Function.increment/1
        )
      end)

    Stream.iterate(start_date, fn current_date -> Date.add(current_date, 7) end)
    |> Stream.take_while(fn current_date ->
      Date.before?(current_date, end_date) or current_date == end_date
    end)
    |> Stream.with_index()
    |> Stream.map(fn {current_date, index} ->
      {index + 1, Map.get(weeks_count_map, current_date, 0)}
    end)
    |> Enum.to_list()
  end

  def get_genres() do
    from(g in Genre)
    |> Repo.all()
  end

  def calculate_genres_count(genres, ratings, ratings_count) do
    initial_map = Enum.map(genres, fn genre -> {genre.id, 0} end) |> Map.new()

    genre_map =
      Enum.reduce(
        ratings,
        initial_map,
        fn rating, map -> Map.update!(map, rating.book.genre_id, &Common.Function.increment/1) end
      )

    Enum.map(genres, fn genre ->
      %{genre: genre, count: genre_map[genre.id] |> calculate_percent_of_ratings(ratings_count)}
    end)
    |> Enum.filter(fn %{count: count} -> count > 0 end)
    # sorting by count desc and name asc, that is why a.count and a.genre.name are mismatched
    |> Enum.sort(fn a, b -> {a.count, b.genre.name} >= {b.count, a.genre.name} end)
  end

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    from(
      rating in Rating,
      join: book in assoc(rating, :book),
      join: author in assoc(book, :author),
      group_by: [author.id, author.first_name, author.middle_name, author.last_name],
      order_by: [desc: fragment("ratings_count"), desc: fragment("ratings_average")],
      select: %{
        ratings_count: fragment("count(*) as ratings_count"),
        ratings_average: fragment("round(avg(?), 2) as ratings_average", rating.score),
        author: %Author{
          id: author.id,
          first_name: author.first_name,
          middle_name: author.middle_name,
          last_name: author.last_name
        }
      }
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of books that have been read more than once.
  """
  def list_reread_books do
    from(
      rating in Rating,
      join: book in assoc(rating, :book),
      group_by: [book.id, book.title, book.sort_title, book.subtitle],
      order_by: [fragment("ratings_count"), book.sort_title],
      having: count() > 1,
      select: %{
        ratings_count: fragment("count(*) as ratings_count"),
        book: %Book{
          id: book.id,
          title: book.title,
          sort_title: book.sort_title,
          subtitle: book.subtitle
        }
      }
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of genres with the list of ratings
  """
  def list_genres_with_ratings_count do
    from(
      rating in Rating,
      join: book in assoc(rating, :book),
      join: genre in assoc(book, :genre),
      group_by: [genre.id, genre.name],
      order_by: [genre.name],
      select: %{
        ratings_count: fragment("count(*) as ratings_count"),
        genre: %Genre{id: genre.id, name: genre.name}
      }
    )
    |> Repo.all()
  end
end
