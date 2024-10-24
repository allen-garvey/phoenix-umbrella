defmodule HabitsWeb.ApiActivityController do
    use HabitsWeb, :controller
  
    alias Habits.Api

    def index(conn, %{"year" => year, "month" => month}) do
      with {:ok, date} <- Habits.Date.date_from(year, month) do
        current_date = Date.utc_today()

        from_date = Habits.Date.sunday_before(date)
        to_date = case Habits.Date.has_same_month_and_year?(date, current_date) do
          true -> Habits.Date.saturday_after(current_date)
          false -> Date.end_of_month(date) |> Habits.Date.saturday_after()
        end
        
        activities = Api.list_activities(from_date, to_date)
        
        render(conn, "index_from_to.json", from: Date.to_iso8601(from_date), to: Date.to_iso8601(to_date), activities: activities)
      else
        {:error, message} -> 
          conn 
            |> put_view(CommonWeb.ApiGenericView) 
            |> put_status(:bad_request) 
            |> render("error.json", message: "#{message}")
      end
    end
end
  