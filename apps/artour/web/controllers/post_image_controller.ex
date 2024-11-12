defmodule Artour.PostImageController do
  use Artour.Web, :controller

  alias Artour.PostImage

  def index(conn, _params) do
    post_images = 
      from(PostImage, order_by: [desc: :id])
      |> Repo.all() 
      |> Repo.preload([:image, :post])
    
    put_view(conn, Artour.SharedView) 
    |> render(
        "index.html", 
        items: post_images, 
        item_name_singular: "post image", 
        column_headings: Artour.PostImageView.attribute_names_short(), 
        row_values_func: &Artour.PostImageView.attribute_values_short/2
      )
  end

  def new(conn, _params) do
    changeset = PostImage.changeset(%PostImage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post_image" => post_image_params, "form_submit_type" => submit_type}) do
    changeset = PostImage.changeset(%PostImage{}, post_image_params)

    case Repo.insert(changeset) do
      {:ok, post_image} ->
        if submit_type == "add_another" do
          changeset = PostImage.changeset(%PostImage{post_id: post_image.post_id})
          conn
            |> put_flash(:info, "Post image saved.")
            |> render("new.html", changeset: changeset)
        else
          conn
            |> put_flash(:info, "Post image created successfully.")
            |> redirect(to: post_image_path(conn, :index))
        end
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_image = Repo.get!(PostImage, id) |> Repo.preload([:image, :post])
    render(conn, "show.html", post_image: post_image)
  end

  def edit(conn, %{"id" => id}) do
    post_image = Repo.get!(PostImage, id)
    changeset = PostImage.changeset(post_image)
    render(conn, "edit.html", post_image: post_image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post_image" => post_image_params}) do
    post_image = Repo.get!(PostImage, id)
    changeset = PostImage.changeset(post_image, post_image_params)

    case Repo.update(changeset) do
      {:ok, post_image} ->
        conn
        |> put_flash(:info, "Post image updated successfully.")
        |> redirect(to: post_image_path(conn, :show, post_image))
      {:error, changeset} ->
        render(conn, "edit.html", post_image: post_image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_image = Repo.get!(PostImage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_image)

    conn
    |> put_flash(:info, "Post image deleted successfully.")
    |> redirect(to: post_image_path(conn, :index))
  end
end
