defmodule Artour.PostTagController do
  use Artour.Web, :controller

  alias Artour.PostTag

  def index(conn, _params) do
    post_tags = Repo.all(from(PostTag, order_by: [desc: :id])) |> Repo.preload([:tag, :post])
    view = view_module(conn)
    put_view(conn, Artour.SharedView) |>
      render("index.html", items: post_tags, item_name_singular: "post tag", column_headings: view.attribute_names_short(), item_view: view,
                                row_values_func_name: :attribute_values_short)
  end

  def new(conn, _params) do
    changeset = PostTag.changeset(%PostTag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post_tag" => post_tag_params}) do
    changeset = PostTag.changeset(%PostTag{}, post_tag_params)

    case Repo.insert(changeset) do
      {:ok, _post_tag} ->
        conn
        |> put_flash(:info, "Post tag created successfully.")
        |> redirect(to: post_tag_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_tag = Repo.get!(PostTag, id) |> Repo.preload([:tag, :post])
    render(conn, "show.html", post_tag: post_tag)
  end

  def edit(conn, %{"id" => id}) do
    post_tag = Repo.get!(PostTag, id)
    changeset = PostTag.changeset(post_tag)
    render(conn, "edit.html", post_tag: post_tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post_tag" => post_tag_params}) do
    post_tag = Repo.get!(PostTag, id)
    changeset = PostTag.changeset(post_tag, post_tag_params)

    case Repo.update(changeset) do
      {:ok, post_tag} ->
        conn
        |> put_flash(:info, "Post tag updated successfully.")
        |> redirect(to: post_tag_path(conn, :show, post_tag))
      {:error, changeset} ->
        render(conn, "edit.html", post_tag: post_tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_tag = Repo.get!(PostTag, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_tag)

    conn
    |> put_flash(:info, "Post tag deleted successfully.")
    |> redirect(to: post_tag_path(conn, :index))
  end
end
