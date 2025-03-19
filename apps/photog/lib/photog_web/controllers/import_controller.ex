defmodule PhotogWeb.ImportController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Import
  alias Common.NumberHelpers

  action_fallback(PhotogWeb.FallbackController)

  def index(conn, %{"limit" => limit, "offset" => offset}) do
    imports = Api.list_imports_with_count_and_limited_images(limit, offset)
    albums_map = Api.albums_map_for_imports_list(limit, offset)

    render(conn, "index_with_count_and_images.json", imports: imports, albums_map: albums_map)
  end

  def index(conn, _params) do
    imports = Api.list_imports_with_count_and_limited_images()
    albums_map = Api.albums_map_for_imports_list()

    render(conn, "index_with_count_and_images.json", imports: imports, albums_map: albums_map)
  end

  def show(conn, %{"id" => id}) do
    import = Api.get_import!(id)
    albums = Api.get_albums_for_import(id)
    persons = Api.get_persons_for_import(id)
    render(conn, "show.json", import: import, albums: albums, persons: persons)
  end

  def show_last(conn, _params) do
    try do
      import = Api.get_last_import!()
      albums = Api.get_albums_for_import(import.id)
      persons = Api.get_persons_for_import(import.id)
      render(conn, "show.json", import: import, albums: albums, persons: persons)
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> put_view(CommonWeb.ApiGenericView)
        |> render("error.json", message: "No imports found.")
    end
  end

  def images_for(conn, %{"id" => id, "excerpt" => "true"}) do
    images = Api.get_images_for_import(id)

    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnails.json", images: images)
  end

  def images_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    images =
      Api.get_images_for_import(
        id,
        NumberHelpers.string_to_integer_with_min(limit, 1, 1),
        NumberHelpers.string_to_integer_with_min(offset, 0)
      )

    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index_thumbnail_list.json", images: images)
  end

  def count(conn, _params) do
    count = Api.imports_count!()

    conn
    |> put_view(CommonWeb.ApiGenericView)
    |> render("data.json", data: count)
  end

  def update(conn, %{"id" => id, "import" => import_params}) do
    import = Api.get_import!(id)

    with {:ok, %Import{} = import} <- Api.update_import(import, import_params) do
      render(conn, "update.json", import: import)
    end
  end
end
