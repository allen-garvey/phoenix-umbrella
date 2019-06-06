defmodule BooklistWeb.LoanView do
  use BooklistWeb, :view

  def to_s(loan) do
  	BooklistWeb.LibraryView.to_s(loan.library) <> "—" <> BooklistWeb.SharedView.us_formatted_date(loan.due_date)
  end
end
