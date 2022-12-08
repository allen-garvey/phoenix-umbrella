defmodule HabitsWeb.CategoryView do
  use HabitsWeb, :view
  alias Habits.Admin.Category

  Common.ViewHelpers.Form.define_map_for_form(true)

  def colors do
    [
      "beige",
      "black",
      "blue",
      "brown",
      "cyan",
      "gold",
      "green",
      "hot-pink",
      "lime",
      "maroon",
      "olive",
      "orange",
      "pink",
      "purple",
      "red",
      "salmon",
      "sandy",
      "sky",
      "yellow",
    ]
  end

  def colors_for_form do
    colors |> Enum.map(fn color -> {String.capitalize(color), color} end)
  end

  def color_style(%Category{} = category) do
    prefix = "center category-color category-color--"

    case Enum.find_value(colors(), false, fn color -> color == category.color end) do
      true -> "#{prefix}#{category.color}"
      false -> ""
    end
  end
end
