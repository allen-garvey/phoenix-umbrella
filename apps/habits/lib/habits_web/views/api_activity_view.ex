defmodule HabitsWeb.ApiActivityView do
  use HabitsWeb, :view

  def render("index_from_to.json", %{from: from, to: to, activities: activities}) do
    %{
      data: %{
        meta: %{
          from: from,
          to: to
        },
        activities: render_many(activities, __MODULE__, "activity.json")
      }
    }
  end

  def render("activity.json", %{api_activity: activity}) do
    %{
      id: activity.id,
      category_id: activity.category_id,
      title: activity.tag.name,
      description: activity.description,
      date: activity.date
    }
  end
end
