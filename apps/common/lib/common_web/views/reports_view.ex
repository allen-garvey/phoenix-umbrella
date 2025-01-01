defmodule CommonWeb.ReportsView do
  use CommonWeb, :view

  def get_items_max_count(items_with_counts) do
    {_, max_count} =
      Enum.max_by(items_with_counts, fn {_, count} -> count end)

    max_count
  end

  def count_per_item_table_item_class(item_count, current_count)
      when is_integer(item_count) and is_integer(current_count) do
    case item_count >= current_count do
      true -> "count-filled"
      false -> ""
    end
  end
end
