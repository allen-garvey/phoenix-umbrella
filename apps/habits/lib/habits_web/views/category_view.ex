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
      "yellow"
    ]
  end

  def colors_for_form do
    colors()
    |> Enum.map(fn color ->
      [key: String.capitalize(color), value: color, class: color_class(color)]
    end)
  end

  def color_style(%Category{} = category) do
    color_class(category.color)
  end

  defp color_class(color) do
    "category-color category-color--#{color}"
  end

  def category_has_activity_style(%Category{} = category) do
    case category.has_daily_activity do
      false -> ""
      true -> "rainbow-border"
    end
  end

  def streak_item_style(%Category{} = category, count) do
    case count do
      0 -> ""
      _ -> color_style(category)
    end
  end
end
