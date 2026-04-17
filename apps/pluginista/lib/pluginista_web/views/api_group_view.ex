defmodule PluginistaWeb.ApiGroupView do
  use PluginistaWeb, :view

  def render("index.json", %{groups: groups}) do
    %{
      data:
        Map.new(Stream.with_index(groups), fn {group, index} ->
          {
            group.id,
            %{
              id: group.id,
              sort: index,
              name: group.name,
              url: ~p"/groups/#{group}"
            }
          }
        end)
    }
  end
end
