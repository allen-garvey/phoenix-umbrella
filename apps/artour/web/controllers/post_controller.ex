defmodule Artour.PostController do
  use Artour.Web, :controller

  alias Artour.Admin
  alias Artour.Post

  def index(conn, _params) do
    posts = Admin.list_posts()
    view = view_module(conn)
    put_view(conn, Artour.SharedView) |>
      render("index.html", items: posts, item_name_singular: "post", column_headings: view.attribute_names_short(), item_view: view,
                                row_values_func_name: :attribute_values_short)
  end

  def new(conn, _params) do
    #set new posts to use last added image by default
    default_cover_image_id = Repo.one!(from i in Artour.Image, select: i.id, order_by: [desc: :id], limit: 1)
    changeset = Post.changeset(%Post{cover_image_id: default_cover_image_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Admin.get_post_for_show!(id)

    render(conn, "show.html", post: post, csrf_token: get_csrf_token())
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  @doc """
  Displays form with images not used in post that can be added to it
  """
  def add_images(conn, %{"post" => post_id}) do
    post = Repo.get!(Post, post_id)

    render conn, "add_images.html", post: post, csrf_token: get_csrf_token()
  end

  @doc """
  Saves images added from add_images form
  images should be array of image_ids
  """
  def save_images(conn, %{"post" => post_id, "images" => images}) do
    post = Repo.get!(Post, post_id)

    #add images to post
    #reverse order so images are ordered oldest to newest
    for image_id <- Enum.reverse(images) do
      changeset = Artour.PostImage.changeset(%Artour.PostImage{}, %{"post_id" => post.id, "image_id" => image_id})
      Repo.insert!(changeset)
    end

    conn
        |> put_flash(:info, "Images added")
        |> redirect(to: post_path(conn, :show, post))
  end


end
