defmodule BooklistWeb.BookView do
  use BooklistWeb, :view

  def to_s(book) do
  	to_s_helper(book.title, book.subtitle)
  end

  def to_s_helper(title, nil) do
    title
  end

  def to_s_helper(title, subtitle) do
    title <> ": " <> subtitle
  end

  @doc """
  Used for super search queries
  """
  def to_search_query(book) do
    book.title
  end

  @doc """
  Maps a list of books into tuples, used for forms
  """
  def map_for_form(books) do
    Enum.map(books, &{to_s(&1), &1.id})
  end

  @doc """
  Path for active books 
  """
  def active_book_path(conn) do
    Routes.book_path(conn, :index, active: "true")
  end

  @doc """
  Path for active books that are unread (i.e. have no ratings)
  """
  def active_unread_book_path(conn) do
    Routes.book_path(conn, :index, active: "true", read: "false")
  end

  @doc """
  Path for inactive books that are unread (i.e. have no ratings)
  """
  def inactive_unread_book_path(conn) do
    Routes.book_path(conn, :index, active: "false", read: "false")
  end

  @doc """
  Path for inactive books that have been read (i.e. have ratings)
  """
  def inactive_read_book_path(conn) do
    Routes.book_path(conn, :index, active: "false", read: "true")
  end

  @doc """
  Path for books that have no location
  """
  def no_location_active_book_path(conn) do
    Routes.book_path(conn, :index, active: "true", location: "false")
  end

  @doc """
  Button text for button to change book's is_active property
  Argument is book's current is_active property
  """
  def is_active_button_text(true) do
    "Active"
  end

  def is_active_button_text(false) do
    "Inactive"
  end

  @doc """
  Button text for button to change book's on_bookshelf property
  Argument is book's current on_bookshelf property
  """
  def on_bookshelf_button_text(true) do
    "On bookshelf"
  end

  def on_bookshelf_button_text(false) do
    "Not on bookshelf"
  end

  @doc """
  CSS classes for buttons to change book's is_active and on_bookshelf properties
  Argument is book's current is_active or on_bookshelf property
  """
  def changeset_button_css_class(true) do
    "btn btn-primary"
  end

  def changeset_button_css_class(false) do
    "btn btn-default"
  end

end
