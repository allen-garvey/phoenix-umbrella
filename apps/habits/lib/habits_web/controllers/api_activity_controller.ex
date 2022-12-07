defmodule HabitsWeb.ApiActivityController do
    use HabitsWeb, :controller
  
    alias Habits.Api
  
    def index(conn, %{"from" => from, "to" => to}) do
      case { Date.from_iso8601(from), Date.from_iso8601(to) } do
        {{:ok, from_date}, {:ok, to_date}} ->
          activities = Api.list_activities(from_date, to_date)
          render(conn, "index_from_to.json", from: from, to: to, activities: activities)
        {{_, from_error}, {_, to_error}} ->
          conn 
          |> put_view(CommonWeb.ApiGenericView) 
          |> put_status(:bad_request) 
          |> render("error.json", message: "From date #{from_error}, to date #{to_error}")
      end
    end
end
  