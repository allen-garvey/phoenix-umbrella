defmodule BlockquoteWeb.CategoryController do
  use BlockquoteWeb, :controller

  alias Blockquote.Admin
  alias Blockquote.Admin.Category

  defp custom_render(conn, template, assigns) do
    assigns = [
      item_name_singular: "category", 
      breadcrumb: {"Categories", category_path(conn, :index)}
    ] ++ assigns
    render(conn, template, assigns)
  end

  def index(conn, _params) do
    categories = Admin.list_categories()
    custom_render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Admin.change_category(%Category{})
    custom_render(conn, "form.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Admin.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: category_path(conn, :show, category))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "form.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Admin.get_category_for_show!(id)
    custom_render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    changeset = Admin.change_category(category)
    custom_render(conn, "form.html", changeset: changeset, category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Admin.get_category!(id)

    case Admin.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: category_path(conn, :show, category))
      {:error, %Ecto.Changeset{} = changeset} ->
        custom_render(conn, "form.html", changeset: changeset, category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    {:ok, _category} = Admin.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: category_path(conn, :index))
  end
end
