defmodule SerenWeb.FileTypeController do
  use SerenWeb, :controller

  alias Seren.Player
  alias Seren.Player.FileType

  action_fallback SerenWeb.FallbackController

  def index(conn, _params) do
    file_types = Player.list_file_types()
    render(conn, "index.json", file_types: file_types)
  end

  def create(conn, %{"file_type" => file_type_params}) do
    with {:ok, %FileType{} = file_type} <- Player.create_file_type(file_type_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", file_type_path(conn, :show, file_type))
      |> render("show.json", file_type: file_type)
    end
  end

  def show(conn, %{"id" => id}) do
    file_type = Player.get_file_type!(id)
    render(conn, "show.json", file_type: file_type)
  end

  def update(conn, %{"id" => id, "file_type" => file_type_params}) do
    file_type = Player.get_file_type!(id)

    with {:ok, %FileType{} = file_type} <- Player.update_file_type(file_type, file_type_params) do
      render(conn, "show.json", file_type: file_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    file_type = Player.get_file_type!(id)
    with {:ok, %FileType{}} <- Player.delete_file_type(file_type) do
      send_resp(conn, :no_content, "")
    end
  end
end
