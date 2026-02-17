defmodule HabitsWeb.ApiTagController do
  use HabitsWeb, :controller

  alias Habits.Api

  def tags_for_category(conn, %{"id" => category_id}) do
    tags = Api.list_tags_for_category(category_id)

    render(conn, "index.json", tags: tags)
  end
end
