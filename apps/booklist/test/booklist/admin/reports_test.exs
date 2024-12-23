defmodule Booklist.ReportsTest do
  use BooklistWeb.DefaultCase

  alias Booklist.Reports
  alias Booklist.Admin.Rating

  test "calculate_ratings_by_week() at beginning of current year" do
    year = 2022
    first_day_of_year = Date.new!(year, 1, 1)
    rating_on_first_day_of_year = %Rating{date_scored: first_day_of_year}
    ratings = [rating_on_first_day_of_year, rating_on_first_day_of_year]

    assert Reports.calculate_ratings_by_week(ratings, year, first_day_of_year) == [{0, 2}]
  end

  test "calculate_ratings_by_week() at beginning and end of past year" do
    year = 2021
    first_day_of_year = Date.new!(year, 1, 1)
    last_day_of_year = Date.new!(year, 12, 31)
    rating_on_first_day_of_year = %Rating{date_scored: first_day_of_year}
    rating_on_last_day_of_year = %Rating{date_scored: last_day_of_year}

    ratings = [
      rating_on_last_day_of_year,
      rating_on_first_day_of_year,
      %Rating{date_scored: Date.new!(year, 1, 3)},
      rating_on_first_day_of_year
    ]

    assert Reports.calculate_ratings_by_week(ratings, year, Date.new!(year + 1, 6, 6)) == [
             {0, 2},
             {1, 1},
             {2, 0},
             {3, 0},
             {4, 0},
             {5, 0},
             {6, 0},
             {7, 0},
             {8, 0},
             {9, 0},
             {10, 0},
             {11, 0},
             {12, 0},
             {13, 0},
             {14, 0},
             {15, 0},
             {16, 0},
             {17, 0},
             {18, 0},
             {19, 0},
             {20, 0},
             {21, 0},
             {22, 0},
             {23, 0},
             {24, 0},
             {25, 0},
             {26, 0},
             {27, 0},
             {28, 0},
             {29, 0},
             {30, 0},
             {31, 0},
             {32, 0},
             {33, 0},
             {34, 0},
             {35, 0},
             {36, 0},
             {37, 0},
             {38, 0},
             {39, 0},
             {40, 0},
             {41, 0},
             {42, 0},
             {43, 0},
             {44, 0},
             {45, 0},
             {46, 0},
             {47, 0},
             {48, 0},
             {49, 0},
             {50, 0},
             {51, 0},
             {52, 1}
           ]
  end
end
