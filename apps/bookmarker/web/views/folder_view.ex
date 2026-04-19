defmodule Bookmarker.FolderView do
  use Bookmarker.Web, :view

  def index_path do
    ~p"/folders"
  end

  def new_path do
    ~p"/folders/new"
  end

  def show_path(folder) do
    ~p"/folders/#{folder}"
  end

  def edit_path(folder) do
    ~p"/folders/#{folder}/edit"
  end
end
