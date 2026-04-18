defmodule BooklistWeb.PageController do
  use BooklistWeb, :controller

  alias Booklist.Admin

  plug(:put_view, html: BooklistWeb.PageView)

  def index(conn, _params) do
    loans_due_soon = Booklist.Admin.list_loans_due_soon()

    render(conn, "index.html", loans_due_soon: loans_due_soon)
  end

  def resources(conn, _params) do
    resources_list = [
      {"Authors", ~p"/authors"},
      {"Books", ~p"/books"},
      {"Book Locations", ~p"/book-locations"},
      {"Genres", ~p"/genres"},
      {"Libraries", ~p"/libraries"},
      {"Loans", ~p"/loans"},
      {"Locations", ~p"/locations"},
      {"Ratings", ~p"/ratings"}
    ]

    render(conn, "resources.html", resources: resources_list)
  end

  def bookshelf(conn, _params) do
    books = Admin.list_bookshelf_books()

    render(conn, "bookshelf.html", books: books)
  end
end
