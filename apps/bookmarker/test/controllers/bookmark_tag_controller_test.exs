defmodule Bookmarker.BookmarkTagControllerTest do
  use Bookmarker.ConnCase

  alias Bookmarker.BookmarkTag
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, bookmark_tag_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing bookmarks tags"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, bookmark_tag_path(conn, :new)
    assert html_response(conn, 200) =~ "New bookmark tag"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, bookmark_tag_path(conn, :create), bookmark_tag: @valid_attrs
    assert redirected_to(conn) == bookmark_tag_path(conn, :index)
    assert Repo.get_by(BookmarkTag, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, bookmark_tag_path(conn, :create), bookmark_tag: @invalid_attrs
    assert html_response(conn, 200) =~ "New bookmark tag"
  end

  test "shows chosen resource", %{conn: conn} do
    bookmark_tag = Repo.insert! %BookmarkTag{}
    conn = get conn, bookmark_tag_path(conn, :show, bookmark_tag)
    assert html_response(conn, 200) =~ "Show bookmark tag"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, bookmark_tag_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bookmark_tag = Repo.insert! %BookmarkTag{}
    conn = get conn, bookmark_tag_path(conn, :edit, bookmark_tag)
    assert html_response(conn, 200) =~ "Edit bookmark tag"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    bookmark_tag = Repo.insert! %BookmarkTag{}
    conn = put conn, bookmark_tag_path(conn, :update, bookmark_tag), bookmark_tag: @valid_attrs
    assert redirected_to(conn) == bookmark_tag_path(conn, :show, bookmark_tag)
    assert Repo.get_by(BookmarkTag, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bookmark_tag = Repo.insert! %BookmarkTag{}
    conn = put conn, bookmark_tag_path(conn, :update, bookmark_tag), bookmark_tag: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit bookmark tag"
  end

  test "deletes chosen resource", %{conn: conn} do
    bookmark_tag = Repo.insert! %BookmarkTag{}
    conn = delete conn, bookmark_tag_path(conn, :delete, bookmark_tag)
    assert redirected_to(conn) == bookmark_tag_path(conn, :index)
    refute Repo.get(BookmarkTag, bookmark_tag.id)
  end
end
