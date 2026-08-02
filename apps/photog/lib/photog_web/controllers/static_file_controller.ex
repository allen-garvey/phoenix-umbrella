defmodule PhotogWeb.StaticFileController do
  use PhotogWeb, :controller

  def serve_thumbnail(conn, %{"path" => path}) do
    serve_file(conn, :thumbnail_source_path, path)
  end

  def serve_image(conn, %{"path" => path}) do
    serve_file(conn, :image_source_path, path)
  end

  defp serve_file(conn, source_path_env_key, path) when is_list(path) do
    case Application.fetch_env(:photog, source_path_env_key) do
      {:ok, image_dir} ->
        conn
        |> put_resp_header("cache-control", "private, max-age=86400")
        |> send_file(200, Path.join([image_dir] ++ path))

      _ ->
        send_resp(conn, 500, "#{source_path_env_key} not set")
    end
  end
end
