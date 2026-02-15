defmodule HabitsWeb.TagController do
  use HabitsWeb, :controller

  alias Habits.Admin
  alias Habits.Admin.Tag

  defp related_fields() do
    [
      categories: Admin.list_categories()
    ]
  end

  def index(conn, _params) do
    tags = Admin.list_tags()
    render(conn, "index.html", tags: tags)
  end

  def new(conn, %{"category_id" => category_id}) do
    changeset = Admin.change_tag(%Tag{category_id: category_id})
    new_page(conn, changeset, "category")
  end

  def new(conn, _params) do
    new_page_initial(conn, nil)
  end

  defp new_page_initial(conn, redirect_action) do
    changeset = Admin.change_tag(%Tag{})

    new_page(conn, changeset, redirect_action)
  end

  defp new_page(conn, changeset, redirect_action) do
    render(conn, :new, [changeset: changeset, redirect: redirect_action] ++ related_fields())
  end

  def create(conn, %{"tag" => tag_params, "redirect" => redirect_action}) do
    create_action(conn, tag_params, redirect_action)
  end

  def create(conn, %{"tag" => tag_params}) do
    create_action(conn, tag_params, nil)
  end

  defp create_action(conn, tag_params, redirect_action) do
    case Admin.create_tag(tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: redirect_path(conn, tag, redirect_action))

      {:error, %Ecto.Changeset{} = changeset} ->
        new_page(conn, changeset, redirect_action)
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Admin.get_tag!(id)
    render(conn, :show, tag: tag)
  end

  def edit(conn, %{"id" => id, "redirect" => redirect_action}) do
    edit_page_initial(conn, id, redirect_action)
  end

  def edit(conn, %{"id" => id}) do
    edit_page_initial(conn, id, nil)
  end

  defp edit_page_initial(conn, id, redirect_action) do
    tag = Admin.get_tag!(id)
    changeset = Admin.change_tag(tag)

    edit_page(conn, tag, changeset, redirect_action)
  end

  defp edit_page(conn, tag, changeset, redirect_action) do
    render(
      conn,
      "edit.html",
      [tag: tag, changeset: changeset, redirect: redirect_action] ++ related_fields()
    )
  end

  def update(conn, %{"id" => id, "tag" => tag_params, "redirect" => redirect_action}) do
    update_action(conn, id, tag_params, redirect_action)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    update_action(conn, id, tag_params, nil)
  end

  defp update_action(conn, id, tag_params, redirect_action) do
    tag = Admin.get_tag!(id)

    case Admin.update_tag(tag, tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: redirect_path(conn, tag, redirect_action))

      {:error, %Ecto.Changeset{} = changeset} ->
        edit_page(conn, tag, changeset, redirect_action)
    end
  end

  defp redirect_path(conn, tag, redirect_action) do
    case redirect_action do
      "category" -> Routes.category_path(conn, :show, tag.category_id)
      _ -> Routes.tag_path(conn, :index)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Admin.get_tag!(id)
    {:ok, _tag} = Admin.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end
end
