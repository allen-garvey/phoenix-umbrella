defmodule MovielistWeb.RatingView do
  use MovielistWeb, :view

  alias MovielistWeb.MovieView
  alias MovielistWeb.SharedView

  def to_s(rating) do
  	MovieView.to_s(rating.movie) <> "—" <> SharedView.us_formatted_date(rating.date_scored)
  end

  def to_s_short(rating) do
  	SharedView.us_formatted_date(rating.date_scored) <> "—" <> Integer.to_string(rating.score)
  end

  def ratings_index_score_sorted_path(conn) do
    Routes.rating_path(conn, :index, sort: :score)
  end

  def css_class_for_score(score) do
  	cond do
  		score >= 85 -> "tr_primary"
  		score >= 79 -> "tr_warning"
  		true 		-> "tr_error"
  	end
  end


end
