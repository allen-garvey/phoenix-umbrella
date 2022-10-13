defmodule PluginistaWeb.PluginCategoryController do
  use PluginistaWeb, :controller

  alias Pluginista.Admin
  alias Pluginista.Admin.PluginCategory

  def index(conn, _params) do
    plugin_categories = Admin.list_plugin_categories()
    render(conn, "index.html", plugin_categories: plugin_categories)
  end

  def new(conn, _params) do
    changeset = Admin.change_plugin_category(%PluginCategory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"plugin_category" => plugin_category_params}) do
    case Admin.create_plugin_category(plugin_category_params) do
      {:ok, plugin_category} ->
        conn
        |> put_flash(:info, "Plugin category created successfully.")
        |> redirect(to: Routes.plugin_category_path(conn, :show, plugin_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    plugin_category = Admin.get_plugin_category!(id)
    render(conn, "show.html", plugin_category: plugin_category)
  end

  def edit(conn, %{"id" => id}) do
    plugin_category = Admin.get_plugin_category!(id)
    changeset = Admin.change_plugin_category(plugin_category)
    render(conn, "edit.html", plugin_category: plugin_category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "plugin_category" => plugin_category_params}) do
    plugin_category = Admin.get_plugin_category!(id)

    case Admin.update_plugin_category(plugin_category, plugin_category_params) do
      {:ok, plugin_category} ->
        conn
        |> put_flash(:info, "Plugin category updated successfully.")
        |> redirect(to: Routes.plugin_category_path(conn, :show, plugin_category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", plugin_category: plugin_category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    plugin_category = Admin.get_plugin_category!(id)
    {:ok, _plugin_category} = Admin.delete_plugin_category(plugin_category)

    conn
    |> put_flash(:info, "Plugin category deleted successfully.")
    |> redirect(to: Routes.plugin_category_path(conn, :index))
  end
end
