defmodule BooklistWeb.LocationController do
  use BooklistWeb, :controller

  alias Booklist.Admin
  alias Booklist.Admin.Location

  def related_fields() do
    [
      libraries: Admin.list_libraries() |> BooklistWeb.LibraryView.map_for_form,
    ]
  end

  def index(conn, _params) do
    locations = Admin.list_locations()
    render(conn, "index.html", locations: locations)
  end

  def new(conn, %{"library_id" => library_id}) do
    changeset = Admin.change_location_with_library(%Location{}, library_id)
    render(conn, "new.html", [changeset: changeset, referrer: "library"] ++ related_fields())
  end

  def new(conn, _params) do
    changeset = Admin.change_location(%Location{})
    render(conn, "new.html", [changeset: changeset] ++ related_fields())
  end

  def create(conn, %{"location" => location_params, "referrer" => "library"}) do
    create_action(conn, location_params, fn (conn, location) -> Routes.library_path(conn, :show, location.library_id) end, "library")
  end

  def create(conn, %{"location" => location_params}) do
    create_action(conn, location_params, fn (conn, location) -> Routes.location_path(conn, :show, location) end)
  end

  def create_action(conn, location_params, success_redirect_callback, referrer \\ nil) when is_function(success_redirect_callback, 2) do
    case Admin.create_location(location_params) do
      {:ok, location} ->
        conn
        |> put_flash(:info, "Location created successfully.")
        |> redirect(to: success_redirect_callback.(conn, location))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", [changeset: changeset, referrer: referrer] ++ related_fields())
    end
  end

  def show(conn, %{"id" => id}) do
    location = Admin.get_location!(id)
    render(conn, "show.html", location: location)
  end

  def edit(conn, %{"id" => id}) do
    location = Admin.get_location!(id)
    changeset = Admin.change_location(location)
    render(conn, "edit.html", [location: location, changeset: changeset] ++ related_fields())
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Admin.get_location!(id)

    case Admin.update_location(location, location_params) do
      {:ok, location} ->
        conn
        |> put_flash(:info, "Location updated successfully.")
        |> redirect(to: Routes.location_path(conn, :show, location))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", [location: location, changeset: changeset] ++ related_fields())
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Admin.get_location!(id)
    item_name = BooklistWeb.LocationView.to_s(location)
    {:ok, _location} = Admin.delete_location(location)

    conn
    |> put_flash(:info, item_name <> " deleted.")
    |> redirect(to: Routes.location_path(conn, :index))
  end
end
