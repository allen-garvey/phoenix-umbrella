defmodule BooklistWeb.RatingView do
  use BooklistWeb, :view
  alias Common.DateHelpers

  def to_s(rating) do
  	BooklistWeb.BookView.to_s(rating.book) <> "—" <> Integer.to_string(rating.score) <> "—" <> DateHelpers.us_formatted_date(rating.date_scored)
  end

  def to_s_short(rating) do
  	DateHelpers.us_formatted_date(rating.date_scored) <> "—" <> Integer.to_string(rating.score)
  end

  def to_reports_heading(rating) do
  	BooklistWeb.BookView.to_s(rating.book) <> "—" <> Integer.to_string(rating.score)
  end
end
