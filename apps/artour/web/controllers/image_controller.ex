defmodule Artour.ImageController do
  use Artour.Web, :controller

  alias Artour.Image
  alias Artour.Admin

  def index(conn, _params) do
    images = Admin.list_images()
    view = view_module(conn)
    put_view(conn, Artour.SharedView) |>
      render("index.html", items: images, item_name_singular: "image", column_headings: view.attribute_names_short(), item_view: view,
                                row_values_func_name: :attribute_values_short)
  end

  def new(conn, _params) do
    changeset = Admin.change_image(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => image_params, "form_submit_type" => submit_type}) do
    changeset = Image.changeset(%Image{}, image_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        if submit_type == "add_another" do
          changeset = Image.changeset(%Image{completion_date: image.completion_date})
          conn
            |> put_flash(:info, Artour.ImageView.display_name(image) <> " saved.")
            |> render("new.html", changeset: changeset)
        else
          conn
            |> put_flash(:info, "Image created successfully.")
            |> redirect(to: image_path(conn, :index))
        end
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Admin.get_image!(id)
    render(conn, "show.html", image: image)
  end

  def edit(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)
    changeset = Image.changeset(image)
    render(conn, "edit.html", image: image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Repo.get!(Image, id)

    case Admin.update_image(image, image_params) do
      {:ok, _image} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: image_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", image: image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: image_path(conn, :index))
  end
end
