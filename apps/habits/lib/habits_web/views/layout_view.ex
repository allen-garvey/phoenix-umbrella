defmodule HabitsWeb.LayoutView do
  use HabitsWeb, :view

  def main_padding(disable_main_padding) do
    case disable_main_padding do
      true -> ""
      _ -> "main-padding"
    end
  end
end
