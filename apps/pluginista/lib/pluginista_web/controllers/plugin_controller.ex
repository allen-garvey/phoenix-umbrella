defmodule PluginistaWeb.PluginController do
  use PluginistaWeb, :controller

  alias Pluginista.Admin
  alias Pluginista.Admin.Plugin

  def index(conn, _params) do
    plugins = Admin.list_plugins()
    render(conn, "index.html", plugins: plugins)
  end

  def new(conn, _params) do
    changeset = Admin.change_plugin(%Plugin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"plugin" => plugin_params}) do
    case Admin.create_plugin(plugin_params) do
      {:ok, plugin} ->
        conn
        |> put_flash(:info, "#{plugin.name} created successfully.")
        |> redirect(to: Routes.plugin_path(conn, :show, plugin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    plugin = Admin.get_plugin!(id)
    render(conn, "show.html", plugin: plugin)
  end

  def edit(conn, %{"id" => id}) do
    plugin = Admin.get_plugin!(id)
    changeset = Admin.change_plugin(plugin)
    render(conn, "edit.html", plugin: plugin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "plugin" => plugin_params}) do
    plugin = Admin.get_plugin!(id)

    case Admin.update_plugin(plugin, plugin_params) do
      {:ok, plugin} ->
        conn
        |> put_flash(:info, "#{plugin.name} updated successfully.")
        |> redirect(to: Routes.plugin_path(conn, :show, plugin))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", plugin: plugin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    plugin = Admin.get_plugin!(id)
    {:ok, _plugin} = Admin.delete_plugin(plugin)

    conn
    |> put_flash(:info, "#{plugin.name} deleted successfully.")
    |> redirect(to: Routes.plugin_path(conn, :index))
  end
end
