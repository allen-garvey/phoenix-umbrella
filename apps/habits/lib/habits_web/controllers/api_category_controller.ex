defmodule HabitsWeb.ApiCategoryController do
    use HabitsWeb, :controller
  
    alias Habits.Admin
  
    def index(conn, _params) do
      categories = Admin.list_categories()
      render(conn, "index.json", categories: categories)
    end
end
  