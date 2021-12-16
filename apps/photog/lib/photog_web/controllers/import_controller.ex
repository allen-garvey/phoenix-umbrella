defmodule PhotogWeb.ImportController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Import

  action_fallback PhotogWeb.FallbackController

  def index(conn, %{"limit" => limit, "offset" => offset}) do
    imports = Api.list_imports_with_count_and_limited_images(limit, offset)
    render(conn, "index_with_count_and_images.json", imports: imports)
  end

  def index(conn, _params) do
    imports = Api.list_imports_with_count_and_limited_images()
    render(conn, "index_with_count_and_images.json", imports: imports)
  end

  def create(conn, %{"import" => import_params}) do
    with {:ok, %Import{} = import} <- Api.create_import(import_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", import_path(conn, :show, import))
      |> render("show.json", import: import)
    end
  end

  def show(conn, %{"id" => id}) do
    import = Api.get_import!(id)
    render(conn, "show.json", import: import)
  end

  def show_last(conn, _params) do
    import = Api.get_last_import!()
    render(conn, "show.json", import: import)
  end

  def images_for(conn, %{"id" => id, "limit" => limit, "offset" => offset}) do
    images = Api.get_images_for_import(id, String.to_integer(limit), String.to_integer(offset))
    
    conn
    |> put_view(PhotogWeb.ImageView)
    |> render("index.json", images: images)
  end

  def count(conn, _params) do
    count = Api.imports_count!()
    render(conn, "count.json", count: count)
  end

  def update(conn, %{"id" => id, "import" => %{"notes" => _notes} = import_params}) do
    import = Api.get_import!(id)

    with {:ok, %Import{} = import} <- Api.update_import(import, import_params) do
      render(conn, "show.json", import: import)
    end
  end

  def delete(conn, %{"id" => id}) do
    import = Api.get_import!(id)

    with {:ok, %Import{}} <- Api.delete_import(import) do
      send_resp(conn, :no_content, "")
    end
  end
end
