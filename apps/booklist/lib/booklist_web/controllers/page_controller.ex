defmodule BooklistWeb.PageController do
  use BooklistWeb, :controller

  alias Booklist.Admin

  def index(conn, _params) do
    loans_due_soon = Booklist.Admin.list_loans_due_soon()
    
    render(conn, "index.html", loans_due_soon: loans_due_soon)
  end

  def resources(conn, _params) do
  	resources_list = [
  		{"Authors", :author_path},
  		{"Books", :book_path},
  		{"Book Locations", :book_location_path},
  		{"Genres", :genre_path},
  		{"Libraries", :library_path},
  		{"Loans", :loan_path},
  		{"Locations", :location_path},
  		{"Ratings", :rating_path},
  	]

  	render(conn, "resources.html", resources: resources_list)
  end

  def bookshelf(conn, _params) do
    books = Admin.list_bookshelf_books()

    render(conn, "bookshelf.html", books: books)
  end
end
