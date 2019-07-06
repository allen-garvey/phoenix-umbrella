defmodule Artour.CategoryController do
  use Artour.Web, :controller

  alias Artour.Category
  alias Artour.CategoryType

  def index(conn, _params) do
    categories = Repo.all(Category.default_order_query())
    view = view_module(conn)
    put_view(conn, Artour.SharedView) |>
      render("index.html", items: categories, item_name_singular: "category", column_headings: view.attribute_names(), item_view: view,
                                row_values_func_name: :attribute_values)
  end

  def new(conn, _params) do
    changeset = Category.changeset(%Category{})
    category_types = CategoryType.form_list()
    render(conn, "new.html", changeset: changeset, category_types: category_types)
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, changeset} ->
        category_types = CategoryType.form_list()
        render(conn, "new.html", changeset: changeset, category_types: category_types)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category)
    category_types = CategoryType.form_list()
    render(conn, "edit.html", category: category, changeset: changeset, category_types: category_types)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: category_path(conn, :show, category))
      {:error, changeset} ->
        category_types = CategoryType.form_list()
    render(conn, "edit.html", category: category, changeset: changeset, category_types: category_types)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: category_path(conn, :index))
  end
end
