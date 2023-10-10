defmodule Booklist.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Booklist.Repo

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
      left_join: book in assoc(r, :book), 
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
    initial_map = Enum.reduce(genres, %{}, fn (genre, map) -> Map.put(map, genre.id, 0)  end)
    genre_map = Enum.reduce(
                  ratings, initial_map, fn (rating, map) -> Map.update!(map, rating.book.genre_id, &increment/1) 
                end)
    Enum.map(genres, fn (genre) -> %{genre: genre, count: genre_map[genre.id] |> calculate_percent_of_ratings(ratings_count)} end)
      |> Enum.filter(fn (%{count: count}) -> count > 0 end)
      |> Enum.sort(fn (a, b) -> 
        case a.count == b.count do
          true -> a.genre.name < b.genre.name
          false -> a.count > b.count
        end 
      end)
  end

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    from(
      author in Author,
      join: book in assoc(author, :books),
      join: rating in assoc(book, :ratings),
      preload: [books: {book, [ratings: rating]}],
      order_by: [author.last_name, author.first_name, author.middle_name]
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of authors with calculated sum of ratings

  ## Examples

      iex> calculate_authors_average_score()
      [{ %Author{}, ratings_count, average_score }]

  """
  def calculate_authors_average_score(authors) do
    authors
    |> Enum.map(fn (author) -> 
        ratings = Enum.flat_map(author.books, fn (book) -> book.ratings end)
        ratings_count = Enum.count(ratings)
        
        ratings_sum = ratings
        |> Enum.reduce(0, fn (rating, sum) -> rating.score + sum end)

        ratings_average = ratings_sum / ratings_count

        {author, ratings_count, ratings_average}
    end)
    |> Enum.sort(fn ({_author_1, ratings_count_1, ratings_average_1}, {_author_2, ratings_count_2, ratings_average_2}) -> 
      cond do
        ratings_count_1 == ratings_count_2 -> ratings_average_1 >= ratings_average_2
        ratings_count_1 >= ratings_count_2 -> true
        true -> false
      end
    end)
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
end