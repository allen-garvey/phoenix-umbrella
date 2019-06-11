defmodule Bookmarker.FolderControllerTest do
  use Bookmarker.ConnCase

  alias Bookmarker.Folder
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, folder_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing folders"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, folder_path(conn, :new)
    assert html_response(conn, 200) =~ "New folder"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, folder_path(conn, :create), folder: @valid_attrs
    assert redirected_to(conn) == folder_path(conn, :index)
    assert Repo.get_by(Folder, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, folder_path(conn, :create), folder: @invalid_attrs
    assert html_response(conn, 200) =~ "New folder"
  end

  test "shows chosen resource", %{conn: conn} do
    folder = Repo.insert! %Folder{}
    conn = get conn, folder_path(conn, :show, folder)
    assert html_response(conn, 200) =~ "Show folder"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, folder_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    folder = Repo.insert! %Folder{}
    conn = get conn, folder_path(conn, :edit, folder)
    assert html_response(conn, 200) =~ "Edit folder"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    folder = Repo.insert! %Folder{}
    conn = put conn, folder_path(conn, :update, folder), folder: @valid_attrs
    assert redirected_to(conn) == folder_path(conn, :show, folder)
    assert Repo.get_by(Folder, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    folder = Repo.insert! %Folder{}
    conn = put conn, folder_path(conn, :update, folder), folder: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit folder"
  end

  test "deletes chosen resource", %{conn: conn} do
    folder = Repo.insert! %Folder{}
    conn = delete conn, folder_path(conn, :delete, folder)
    assert redirected_to(conn) == folder_path(conn, :index)
    refute Repo.get(Folder, folder.id)
  end
end
