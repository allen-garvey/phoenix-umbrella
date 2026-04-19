defmodule Bookmarker.BookmarkView do
  use Bookmarker.Web, :view

  def index_path do
    ~p"/bookmarks"
  end

  def new_path do
    ~p"/bookmarks/new"
  end

  def show_path(bookmark) do
    ~p"/bookmarks/#{bookmark}"
  end

  def edit_path(bookmark) do
    ~p"/bookmarks/#{bookmark}/edit"
  end
end
