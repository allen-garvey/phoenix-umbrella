defmodule MovielistWeb.StreamerController do
  use MovielistWeb, :controller

  alias Movielist.Admin
  alias Movielist.Admin.Streamer

  def index(conn, _params) do
    streamers = Admin.list_streamers()
    render(conn, "index.html", streamers: streamers, page_atom: :streamers_index)
  end

  def new(conn, _params) do
    changeset = Admin.change_streamer(%Streamer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"streamer" => streamer_params}) do
    case Admin.create_streamer(streamer_params) do
      {:ok, streamer} ->
        conn
        |> put_flash(:info, "Streamer created successfully.")
        |> redirect(to: Routes.streamer_path(conn, :show, streamer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    streamer = Admin.get_streamer!(id)
    render(conn, "show.html", streamer: streamer)
  end

  def edit(conn, %{"id" => id}) do
    streamer = Admin.get_streamer!(id)
    changeset = Admin.change_streamer(streamer)
    render(conn, "edit.html", streamer: streamer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "streamer" => streamer_params}) do
    streamer = Admin.get_streamer!(id)

    case Admin.update_streamer(streamer, streamer_params) do
      {:ok, streamer} ->
        conn
        |> put_flash(:info, "Streamer updated successfully.")
        |> redirect(to: Routes.streamer_path(conn, :show, streamer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", streamer: streamer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    streamer = Admin.get_streamer!(id)
    {:ok, _streamer} = Admin.delete_streamer(streamer)

    conn
    |> put_flash(:info, "Streamer deleted successfully.")
    |> redirect(to: Routes.streamer_path(conn, :index))
  end
end
