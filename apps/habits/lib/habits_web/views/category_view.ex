defmodule HabitsWeb.CategoryView do
  use HabitsWeb, :view
  alias Habits.Admin.Category

  Common.ViewHelpers.Form.define_map_for_form(true)

  def color_style(%Category{} = category) do
    prefix = "category-color category-color--"

    case category.color do
      "green" -> "#{prefix}green"
      "black" -> "#{prefix}black"
      "red" -> "#{prefix}red"
      _ -> ""
    end
  end
end
