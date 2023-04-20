defmodule PluginistaWeb.ApiCategoryView do
    use PluginistaWeb, :view

    def render("index.json", %{conn: conn, categories: categories}) do
        %{
            data: Map.new(Stream.with_index(categories), fn {category, index} -> 
                {
                    category.id,
                    %{
                        id: category.id,
                        sort: index,
                        name: category.name,
                        group_id: category.group_id,
                        color: category_color(category),
                        url: Routes.category_path(conn, :show, category),
                    }
                }
            end)
        }
    end

    def category_color(category) do
        colors = [
            "blue",
            "teal",
            "magenta",
            "yellow",
            "orange",
            "green",
            "red",
            "cyan",
            "lime",
            "bordeaux",
            "violet",
            "black",
        ]
        
        Enum.at(colors, rem(category.id, Enum.count(colors)))
    end
  
end
  