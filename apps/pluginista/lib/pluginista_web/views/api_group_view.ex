defmodule PluginistaWeb.ApiGroupView do
    use PluginistaWeb, :view

    def render("index.json", %{conn: conn, groups: groups}) do
        %{
            data: Map.new(groups, fn group -> 
                {
                    group.id,
                    %{
                        id: group.id,
                        name: group.name,
                        url: Routes.group_path(conn, :show, group),
                    }
                }
            end)
        }
    end
  
end
  