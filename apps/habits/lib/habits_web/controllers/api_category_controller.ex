defmodule HabitsWeb.ApiCategoryController do
  use HabitsWeb, :controller

  alias Habits.Admin

  def index(conn, _params) do
    categories = Admin.list_categories()
    render(conn, "index.json", categories: categories)
  end

  def recent_activities_for(conn, %{"id" => id}) do
    activities = Admin.recent_activity_titles_for(id)

    conn
    |> put_view(HabitsWeb.ApiActivityView)
    |> render("activity_titles.json", activities: activities)
  end
end
