defmodule Artour.FormatControllerTest do
  use Artour.ConnCase

  alias Artour.Format
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, format_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing formats"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, format_path(conn, :new)
    assert html_response(conn, 200) =~ "New format"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, format_path(conn, :create), format: @valid_attrs
    assert redirected_to(conn) == format_path(conn, :index)
    assert Repo.get_by(Format, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, format_path(conn, :create), format: @invalid_attrs
    assert html_response(conn, 200) =~ "New format"
  end

  test "shows chosen resource", %{conn: conn} do
    format = Repo.insert! %Format{}
    conn = get conn, format_path(conn, :show, format)
    assert html_response(conn, 200) =~ "Show format"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, format_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    format = Repo.insert! %Format{}
    conn = get conn, format_path(conn, :edit, format)
    assert html_response(conn, 200) =~ "Edit format"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    format = Repo.insert! %Format{}
    conn = put conn, format_path(conn, :update, format), format: @valid_attrs
    assert redirected_to(conn) == format_path(conn, :show, format)
    assert Repo.get_by(Format, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    format = Repo.insert! %Format{}
    conn = put conn, format_path(conn, :update, format), format: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit format"
  end

  test "deletes chosen resource", %{conn: conn} do
    format = Repo.insert! %Format{}
    conn = delete conn, format_path(conn, :delete, format)
    assert redirected_to(conn) == format_path(conn, :index)
    refute Repo.get(Format, format.id)
  end
end
