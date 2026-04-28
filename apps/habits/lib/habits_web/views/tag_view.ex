defmodule HabitsWeb.TagView do
  alias HabitsWeb.CategoryView
  use HabitsWeb, :view
  # alias Habits.Admin.Tag

  Common.ViewHelpers.Form.define_map_for_form(true)

  def tag_link_title(tag) do
    link(tag.name, to: ~p"/tags/#{tag}")
  end

  def tag_summary_path(tag) do
    ~p"/categories/#{tag.category_id}/summary?tags[]=#{tag}"
  end
end
