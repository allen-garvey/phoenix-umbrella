defmodule PluginistaWeb.MakerController do
  use PluginistaWeb, :controller

  alias Pluginista.Admin
  alias Pluginista.Admin.Maker

  def index(conn, _params) do
    makers = Admin.list_makers()
    render(conn, "index.html", makers: makers)
  end

  def new(conn, _params) do
    changeset = Admin.change_maker(%Maker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create_succeeded(conn, "true") do
    changeset = Admin.change_maker(%Maker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create_succeeded(conn, _save_another) do
    redirect(conn, to: Routes.maker_path(conn, :index))
  end

  def create(conn, %{"maker" => maker_params, "save_another" => save_another}) do
    case Admin.create_maker(maker_params) do
      {:ok, maker} ->
        conn
        |> put_flash(:info, "#{maker.name} created successfully.")
        |> create_succeeded(save_another)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    maker = Admin.get_maker!(id)
    render(conn, "show.html", maker: maker)
  end

  def edit(conn, %{"id" => id}) do
    maker = Admin.get_maker!(id)
    changeset = Admin.change_maker(maker)
    render(conn, "edit.html", maker: maker, changeset: changeset)
  end

  def update(conn, %{"id" => id, "maker" => maker_params}) do
    maker = Admin.get_maker!(id)

    case Admin.update_maker(maker, maker_params) do
      {:ok, maker} ->
        conn
        |> put_flash(:info, "#{maker.name} updated successfully.")
        |> redirect(to: Routes.maker_path(conn, :index, maker))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", maker: maker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    maker = Admin.get_maker!(id)
    {:ok, _maker} = Admin.delete_maker(maker)

    conn
    |> put_flash(:info, "#{maker.name} deleted successfully.")
    |> redirect(to: Routes.maker_path(conn, :index))
  end
end
