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

  def import_images(conn, _params) do
    render(conn, "import.html", csrf_token: get_csrf_token())
  end

  def new(conn, _params) do
    changeset = Admin.change_image(%Image{})
    formats = Artour.Format.form_list(Repo)
    render(conn, "new.html", changeset: changeset, formats: formats)
  end

  def create(conn, %{"image" => image_params, "form_submit_type" => submit_type}) do
    changeset = Image.changeset(%Image{}, image_params)

    case Repo.insert(changeset) do
      {:ok, image} ->
        if submit_type == "add_another" do
          changeset = Image.changeset(%Image{format_id: image.format_id, completion_date: image.completion_date})
          formats = Artour.Format.form_list(Repo)
          conn
            |> put_flash(:info, Artour.ImageView.display_name(image) <> " saved.")
            |> render("new.html", changeset: changeset, formats: formats)
        else
          conn
            |> put_flash(:info, "Image created successfully.")
            |> redirect(to: image_path(conn, :index))
        end
      {:error, changeset} ->
        formats = Artour.Format.form_list(Repo)
        render(conn, "new.html", changeset: changeset, formats: formats)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Admin.get_image!(id)
    render(conn, "show.html", image: image)
  end

  def edit(conn, %{"id" => id}) do
    image = Repo.get!(Image, id)
    changeset = Image.changeset(image)
    formats = Artour.Format.form_list(Repo)
    render(conn, "edit.html", image: image, changeset: changeset, formats: formats)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Repo.get!(Image, id)

    case Admin.update_image(image, image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: image_path(conn, :show, image))
      {:error, changeset} ->
        formats = Artour.Format.form_list(Repo)
        render(conn, "edit.html", image: image, changeset: changeset, formats: formats)
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
