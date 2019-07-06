defmodule Artour.PublicTagControllerTest do
  use Artour.ConnCase

  alias Artour.PublicTag
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, public_tag_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing public tags"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, public_tag_path(conn, :new)
    assert html_response(conn, 200) =~ "New public tag"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, public_tag_path(conn, :create), public_tag: @valid_attrs
    assert redirected_to(conn) == public_tag_path(conn, :index)
    assert Repo.get_by(PublicTag, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, public_tag_path(conn, :create), public_tag: @invalid_attrs
    assert html_response(conn, 200) =~ "New public tag"
  end

  test "shows chosen resource", %{conn: conn} do
    public_tag = Repo.insert! %PublicTag{}
    conn = get conn, public_tag_path(conn, :show, public_tag)
    assert html_response(conn, 200) =~ "Show public tag"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, public_tag_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    public_tag = Repo.insert! %PublicTag{}
    conn = get conn, public_tag_path(conn, :edit, public_tag)
    assert html_response(conn, 200) =~ "Edit public tag"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    public_tag = Repo.insert! %PublicTag{}
    conn = put conn, public_tag_path(conn, :update, public_tag), public_tag: @valid_attrs
    assert redirected_to(conn) == public_tag_path(conn, :show, public_tag)
    assert Repo.get_by(PublicTag, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    public_tag = Repo.insert! %PublicTag{}
    conn = put conn, public_tag_path(conn, :update, public_tag), public_tag: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit public tag"
  end

  test "deletes chosen resource", %{conn: conn} do
    public_tag = Repo.insert! %PublicTag{}
    conn = delete conn, public_tag_path(conn, :delete, public_tag)
    assert redirected_to(conn) == public_tag_path(conn, :index)
    refute Repo.get(PublicTag, public_tag.id)
  end
end
