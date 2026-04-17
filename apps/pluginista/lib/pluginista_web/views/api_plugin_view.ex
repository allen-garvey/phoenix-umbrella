defmodule PluginistaWeb.ApiPluginView do
  use PluginistaWeb, :view

  def render("index.json", %{plugins: plugins}) do
    %{
      data:
        Enum.map(plugins, fn plugin ->
          %{
            id: plugin.id,
            name: plugin.name,
            cost: plugin.cost,
            acquisition_date: plugin.acquisition_date,
            group_id: plugin.group_id,
            maker_id: plugin.maker_id,
            category_ids:
              Enum.map(plugin.plugin_categories, fn plugin_category ->
                plugin_category.category_id
              end),
            url: ~p"/plugins/#{plugin}",
            edit_url: ~p"/plugins/#{plugin}/edit"
          }
        end)
    }
  end
end
