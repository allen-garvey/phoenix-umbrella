defmodule BlockquoteWeb.AdminController do
  use BlockquoteWeb, :controller

  plug(:put_view, html: BlockquoteWeb.AdminView)

  def index(conn, _params) do
    fields = [
      {
        "Authors",
        BlockquoteWeb.AuthorView.index_path(),
        BlockquoteWeb.AuthorView.new_path()
      },
      {
        "Categories",
        BlockquoteWeb.CategoryView.index_path(),
        BlockquoteWeb.CategoryView.new_path()
      },
      {
        "Daily Quotes",
        BlockquoteWeb.DailyQuoteView.index_path(),
        BlockquoteWeb.DailyQuoteView.new_path()
      },
      {
        "Quotes",
        BlockquoteWeb.QuoteView.index_path(),
        BlockquoteWeb.QuoteView.new_path()
      },
      {
        "Parent Sources",
        BlockquoteWeb.ParentSourceView.index_path(),
        BlockquoteWeb.ParentSourceView.new_path()
      },
      {
        "Sources",
        BlockquoteWeb.SourceView.index_path(),
        BlockquoteWeb.SourceView.new_path()
      },
      {
        "Source Types",
        BlockquoteWeb.SourceTypeView.index_path(),
        BlockquoteWeb.SourceTypeView.new_path()
      }
    ]

    render(conn, "index.html", fields: fields)
  end
end
