defmodule Artour.TagController do
  use Artour.Web, :controller

  alias Artour.Tag

  def index(conn, _params) do
    tags = Repo.all(Tag.default_order_query())
    view = view_module(conn)
    put_view(conn, Artour.SharedView) |>
      render("index.html", items: tags, item_name_singular: "tag", column_headings: view.attribute_names(), item_view: view,
                                row_values_func_name: :attribute_values)
  end

  def new(conn, _params) do
    changeset = Tag.changeset(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}) do
    changeset = Tag.changeset(%Tag{}, tag_params)

    case Repo.insert(changeset) do
      {:ok, _tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: tag_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    render(conn, "show.html", tag: tag)
  end

  def edit(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag)
    render(conn, "edit.html", tag: tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag, tag_params)

    case Repo.update(changeset) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: tag_path(conn, :show, tag))
      {:error, changeset} ->
        render(conn, "edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: tag_path(conn, :index))
  end
end
