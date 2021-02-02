defmodule Booklist.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias Booklist.Repo

  alias Booklist.Admin.Rating

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
      Map.update!(week_map, week_number, fn (current_value) -> current_value + 1 end)
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
end