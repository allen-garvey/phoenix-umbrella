defmodule HabitsWeb.TagView do
  alias HabitsWeb.CategoryView
  use HabitsWeb, :view
  # alias Habits.Admin.Tag

  Common.ViewHelpers.Form.define_map_for_form(true)

  def tag_link_title(tag) do
    link(tag.name, to: ~p"/tags/#{tag}")
  end
end
