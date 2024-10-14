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

  def increment(num) do
    num + 1
  end

  def calculate_percent_of_ratings(total, ratings_count) do
    total / max(ratings_count, 1) * 100 |> Float.round(2)
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
      select: %{
        id: r.id,
        score: r.score,
        date_scored: r.date_scored,
        week_number: fragment("CAST(extract(week FROM ?) AS integer)", r.date_scored),
        book: %{
          id: book.id,
          title: book.title,
          sort_title: book.sort_title,
          subtitle: book.subtitle,
          is_fiction: book.is_fiction,
          genre_id: book.genre_id
        }
      }
    )
      |> Repo.all
  end

  def calculate_rating_total(ratings) do
    Enum.reduce(ratings, 0, fn (rating, total) -> total + rating.score end)
  end

  def calculate_nonfiction_count(ratings) do    
    Enum.count(ratings, fn (rating) -> rating.book.is_fiction == false end)
  end

  def calculate_ratings_by_week(ratings, is_past_year) do
    week_numbers = 1..53
    week_map_initial = week_numbers |> Enum.map(fn (i) -> {i, 0} end) |> Map.new
    week_map = Enum.reduce(ratings, week_map_initial, fn (%{week_number: week_number}, week_map) -> 
      Map.update!(week_map, week_number, &increment/1)
    end)

    raw_week_count = Enum.map(week_numbers, fn (week_number) -> %{week_number: week_number, count: week_map[week_number]} end)

    case is_past_year do
      true -> 
        Enum.filter(raw_week_count, fn (%{week_number: week_number, count: count}) -> week_number < 53 or count > 0 end)
          |> format_last_week_of_year
      false -> 
        current_date = Common.ModelHelpers.Date.today
        {_, current_week_num} = {current_date.year, current_date.month, current_date.day} |> :calendar.iso_week_number
        Enum.filter(raw_week_count, fn (%{week_number: week_number, count: count}) -> week_number <= current_week_num or (week_number == 53 and count > 0) end) |> format_last_week_of_year
    end
  end

  def format_last_week_of_year(ratings_by_week) do
    last_week = List.last(ratings_by_week)

    case last_week.week_number do
      53 ->
        [last_week | ratings_by_week]
          |> List.delete_at(-1)
      _  -> ratings_by_week
    end
  end

  def get_genres() do
    from(
      g in Genre
    )
    |> Repo.all
  end

  def calculate_genres_count(genres, ratings, ratings_count) do
    initial_map = Enum.map(genres, fn (genre) -> {genre.id, 0} end) |> Map.new
    genre_map = Enum.reduce(
                  ratings, initial_map, fn (rating, map) -> Map.update!(map, rating.book.genre_id, &increment/1) 
                end)
    Enum.map(genres, fn (genre) -> %{genre: genre, count: genre_map[genre.id] |> calculate_percent_of_ratings(ratings_count)} end)
      |> Enum.filter(fn (%{count: count}) -> count > 0 end)
      # sorting by count desc and name asc, that is why a.count and a.genre.name are mismatched
      |> Enum.sort(fn (a, b) -> {a.count, b.genre.name} >= {b.count, a.genre.name} end)
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
      select: 
        %{
          ratings_count: fragment("count(*) as ratings_count"),
          ratings_average: fragment("round(avg(?), 2) as ratings_average", rating.score),
          author: 
            %Author{id: author.id, first_name: author.first_name, middle_name: author.middle_name, last_name: author.last_name}
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
      select: %{ratings_count: fragment("count(*) as ratings_count"), book: %Book{id: book.id, title: book.title, sort_title: book.sort_title, subtitle: book.subtitle}}
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
      select: %{ratings_count: fragment("count(*) as ratings_count"), genre: %Genre{id: genre.id, name: genre.name}}
    )
    |> Repo.all()
  end
end