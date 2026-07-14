defmodule SupersearchWeb.EngineController do
  use GrenadierWeb, :controller

  alias Supersearch.Admin
  alias Supersearch.Admin.Engine

  plug(:put_view, html: SupersearchWeb.EngineView)

  def index(conn, _params) do
    engines = Admin.list_engines()
    render(conn, "index.html", engines: engines)
  end

  def new(conn, _params) do
    changeset = Admin.change_engine(%Engine{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"engine" => engine_params}) do
    case Admin.create_engine(engine_params) do
      {:ok, _engine} ->
        conn
        |> put_flash(:info, "Engine created successfully.")
        |> redirect(to: ~p"/admin/engines")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    engine = Admin.get_engine!(id)
    render(conn, "show.html", engine: engine)
  end

  def edit(conn, %{"id" => id}) do
    engine = Admin.get_engine!(id)
    changeset = Admin.change_engine(engine)
    render(conn, "edit.html", engine: engine, changeset: changeset)
  end

  def update(conn, %{"id" => id, "engine" => engine_params}) do
    engine = Admin.get_engine!(id)

    case Admin.update_engine(engine, engine_params) do
      {:ok, engine} ->
        conn
        |> put_flash(:info, "Engine updated successfully.")
        |> redirect(to: ~p"/admin/engines/#{engine}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", engine: engine, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    engine = Admin.get_engine!(id)
    {:ok, _engine} = Admin.delete_engine(engine)

    conn
    |> put_flash(:info, "Engine deleted successfully.")
    |> redirect(to: ~p"/admin/engines")
  end
end
