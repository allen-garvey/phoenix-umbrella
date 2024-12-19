defmodule HabitsWeb.CategoryController do
  use HabitsWeb, :controller

  alias Habits.Admin
  alias Habits.Admin.Category
  alias HabitsWeb.CategoryView

  def index(conn, _params) do
    categories = Admin.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Admin.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Admin.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "#{CategoryView.to_s(category)} created successfully.")
        |> redirect(to: Routes.category_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    changeset = Admin.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Admin.get_category!(id)

    case Admin.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "#{CategoryView.to_s(category)} updated successfully.")
        |> redirect(to: Routes.category_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    {:ok, _category} = Admin.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end

  def activities_list(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    activities = Admin.activites_for_category(id)

    render(conn, "activities_list.html", category: category, activities: activities)
  end
end
