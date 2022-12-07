defmodule HabitsWeb.ApiActivityView do
    use HabitsWeb, :view
    
    def render("index_from_to.json", %{from: from, to: to, activities: activities}) do
        %{
            meta: %{
                from: from,
                to: to,
            },
            data: render_many(activities, __MODULE__, "activity.json"),
        }
    end

    def render("activity.json", %{api_activity: activity}) do
        %{
            id: activity.id,
            category_id: activity.category_id,
            title: activity.title,
            description: activity.description,
            date: activity.date,
        }
    end
end
  