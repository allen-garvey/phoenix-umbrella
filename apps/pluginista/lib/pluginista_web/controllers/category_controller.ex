defmodule PluginistaWeb.CategoryController do
  use PluginistaWeb, :controller

  alias Pluginista.Admin
  alias Pluginista.Admin.Category

  def related_fields() do
    [
      groups: Admin.list_groups() |> PluginistaWeb.GroupView.map_for_form,
    ]
  end

  def index(conn, _params) do
    categories = Admin.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Admin.change_category(%Category{})
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create_succeeded(conn, category, "true") do
    changeset = Admin.change_category(%Category{ group_id: category.group_id })
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create_succeeded(conn, category, _save_another) do
    redirect(conn, to: Routes.category_path(conn, :show, category))
  end

  def create(conn, %{"category" => category_params} = params) do
    case Admin.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "#{category.name} created successfully.")
        |> create_succeeded(category, params["save_another"])

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    changeset = Admin.change_category(category)
    render(conn, "edit.html", [category: category, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Admin.get_category!(id)

    case Admin.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "#{category.name} updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [category: category, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    {:ok, _category} = Admin.delete_category(category)

    conn
    |> put_flash(:info, "#{category.name} deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end
end
