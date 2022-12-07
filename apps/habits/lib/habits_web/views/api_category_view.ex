defmodule HabitsWeb.ApiCategoryView do
    use HabitsWeb, :view
    
    def render("index.json", %{categories: categories}) do
        %{data: render_many(categories, __MODULE__, "category.json")}
    end

    def render("category.json", %{api_category: category}) do
        %{
            id: category.id,
            name: category.name,
            color: category.color,
        }
    end
end
  