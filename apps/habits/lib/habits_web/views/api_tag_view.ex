defmodule HabitsWeb.ApiTagView do
  use HabitsWeb, :view

  def render("index.json", %{tags: tags}) do
    %{data: Enum.map(tags, fn tag -> %{id: tag.id, name: tag.name} end)}
  end
end
