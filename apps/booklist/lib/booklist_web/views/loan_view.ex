defmodule BooklistWeb.LoanView do
  use BooklistWeb, :view

  def to_s(loan) do
    BooklistWeb.LibraryView.to_s(loan.library) <>
      "—" <> Common.DateHelpers.us_formatted_date(loan.due_date)
  end

  def show_path(loan) do
    ~p"/loans/#{loan}"
  end
end
