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
        case safe_path_join(path, image_dir) do
          {:ok, full_path} ->
            conn
            |> put_resp_header("cache-control", "private, max-age=86400")
            |> send_file(200, full_path)

          _ ->
            send_resp(conn, 404, "File not found")
        end

      _ ->
        send_resp(conn, 500, "#{source_path_env_key} not set")
    end
  end

  # joins paths if there is no directory traversal
  def safe_path_join(path, base_path) when is_list(path) do
    full_path = Path.join([base_path] ++ path) |> Path.expand()

    case String.starts_with?(full_path, base_path) do
      true -> {:ok, full_path}
      _ -> :error
    end
  end
end
