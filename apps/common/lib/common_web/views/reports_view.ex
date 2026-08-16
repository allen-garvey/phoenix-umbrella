defmodule CommonWeb.ReportsView do
  use CommonWeb, :view

  def get_items_max_count(items_with_counts) do
    {_, max_count} =
      Enum.max_by(items_with_counts, fn {_, count} -> count end)

    max(max_count, 1)
  end

  # takes a list of items in the format {key, integer_count}
  # applies scaling to the counts so they are in a smaller range
  def normalize_items_with_counts(items) do
    max_count = get_items_max_count(items)

    divisor =
      cond do
        max_count <= 24 -> 1
        max_count <= 99 -> 5
        true -> 10
      end

    Enum.map(items, fn {key, count} ->
      {key, round(count / divisor)}
    end)
  end

  def count_per_item_table_item_class(item_count, current_count)
      when is_integer(item_count) and is_integer(current_count) do
    case item_count >= current_count do
      true -> "count-filled"
      false -> ""
    end
  end
end
