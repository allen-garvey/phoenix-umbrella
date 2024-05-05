defmodule PluginistaWeb.PluginController do
  use PluginistaWeb, :controller

  alias Pluginista.Admin
  alias Pluginista.Admin.Plugin
  alias Pluginista.Admin.Maker

  def related_fields() do
    [
      groups: Admin.list_groups() |> PluginistaWeb.GroupView.map_for_form,
      makers: Admin.list_makers() |> PluginistaWeb.MakerView.map_for_form,
      categories: Admin.list_categories(),
    ]
  end

  def index(conn, _params) do
    plugins = Admin.list_plugins()
    render(conn, "index.html", plugins: plugins)
  end

  defp get_optional_id(result) do
    case result do
      nil -> nil
      result -> result.id
    end
  end

  def new(conn, _params) do
    maker_id = Admin.get_recent_popular_maker() |> get_optional_id()
    group_id = Admin.get_recent_popular_group() |> get_optional_id()

    changeset = Admin.change_plugin(%Plugin{maker_id: maker_id, group_id: group_id})
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  defp create_succeeded(conn, plugin, "true") do
    changeset = Admin.change_plugin(%Plugin{ group_id: plugin.group_id, maker_id: plugin.maker_id, acquisition_date: plugin.acquisition_date, })
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  defp create_succeeded(conn, plugin, _save_another) do
    redirect(conn, to: Routes.plugin_path(conn, :show, plugin))
  end

  def create(conn, %{"plugin" => plugin_params} = params) do
    category_ids = Map.get(params, "categories", [])
    
    case Admin.create_plugin(plugin_params) do
      {:ok, plugin} ->
        conn
        |> create_categories_for_plugin(plugin.id, category_ids)
        |> put_flash(:info, "#{plugin.name} created successfully.")
        |> create_succeeded(plugin, params["save_another"])

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    plugin = Admin.get_plugin!(id)
    categories = Admin.list_categories_for_group(plugin.group_id)
    render(conn, "show.html", plugin: plugin, categories: categories)
  end

  def edit(conn, %{"id" => id}) do
    plugin = Admin.get_plugin!(id)
    changeset = Admin.change_plugin(plugin)
    render(conn, "edit.html", [plugin: plugin, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "plugin" => plugin_params}) do
    plugin = Admin.get_plugin!(id)

    case Admin.update_plugin(plugin, plugin_params) do
      {:ok, plugin} ->
        conn
        |> put_flash(:info, "#{plugin.name} updated successfully.")
        |> redirect(to: Routes.plugin_path(conn, :show, plugin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [plugin: plugin, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    plugin = Admin.get_plugin!(id)
    {:ok, _plugin} = Admin.delete_plugin(plugin)

    conn
    |> put_flash(:info, "#{plugin.name} deleted successfully.")
    |> redirect(to: Routes.plugin_path(conn, :index))
  end

  def update_categories(conn, %{"id" => plugin_id, "categories" => category_ids}) do
    Admin.delete_plugin_categories_for_plugin(plugin_id)

    create_categories_for_plugin(conn, plugin_id, category_ids)
      |> put_flash(:info, "Categories updated.")
      |> redirect(to: Routes.plugin_path(conn, :show, plugin_id))
  end

  def update_categories(conn, %{"id" => plugin_id}) do
    Admin.delete_plugin_categories_for_plugin(plugin_id)

    conn
      |> put_flash(:info, "Categories updated.")
      |> redirect(to: Routes.plugin_path(conn, :show, plugin_id))
  end

  defp create_categories_for_plugin(conn, plugin_id, category_ids) when is_list(category_ids) do
    for category_id <- category_ids do
      Admin.create_plugin_category(%{plugin_id: plugin_id, category_id: category_id})
    end
    conn
  end
end
