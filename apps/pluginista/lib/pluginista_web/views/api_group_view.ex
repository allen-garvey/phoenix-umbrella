defmodule PluginistaWeb.ApiGroupView do
    use PluginistaWeb, :view

    def render("index.json", %{conn: conn, groups: groups}) do
        %{
            data: Map.new(Stream.with_index(groups), fn {group, index} -> 
                {
                    group.id,
                    %{
                        id: group.id,
                        sort: index,
                        name: group.name,
                        url: Routes.group_path(conn, :show, group),
                    }
                }
            end)
        }
    end
  
end
  