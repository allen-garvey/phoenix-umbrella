defmodule BooklistWeb.PageController do
  use BooklistWeb, :controller

  alias Booklist.Admin

  def index(conn, _params) do
    loans_due_soon = Booklist.Admin.list_loans_due_soon()
    
    render(conn, "index.html", loans_due_soon: loans_due_soon)
  end

  def resources(conn, _params) do
  	resources_list = [
  		{"Authors", Routes.author_path(conn, :index)},
  		{"Books", Routes.book_path(conn, :index)},
  		{"Book Locations", Routes.book_location_path(conn, :index)},
  		{"Genres", Routes.genre_path(conn, :index)},
  		{"Libraries", Routes.library_path(conn, :index)},
  		{"Loans", Routes.loan_path(conn, :index)},
  		{"Locations", Routes.location_path(conn, :index)},
  		{"Ratings", Routes.rating_path(conn, :index)},
  	]

  	render(conn, "resources.html", resources: resources_list)
  end

  def bookshelf(conn, _params) do
    books = Admin.list_bookshelf_books()

    render(conn, "bookshelf.html", books: books)
  end
end
