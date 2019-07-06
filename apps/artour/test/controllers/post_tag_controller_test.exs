defmodule Artour.PostTagControllerTest do
  use Artour.ConnCase

  alias Artour.PostTag
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_tag_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing post tags"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_tag_path(conn, :new)
    assert html_response(conn, 200) =~ "New post tag"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_tag_path(conn, :create), post_tag: @valid_attrs
    assert redirected_to(conn) == post_tag_path(conn, :index)
    assert Repo.get_by(PostTag, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_tag_path(conn, :create), post_tag: @invalid_attrs
    assert html_response(conn, 200) =~ "New post tag"
  end

  test "shows chosen resource", %{conn: conn} do
    post_tag = Repo.insert! %PostTag{}
    conn = get conn, post_tag_path(conn, :show, post_tag)
    assert html_response(conn, 200) =~ "Show post tag"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_tag_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post_tag = Repo.insert! %PostTag{}
    conn = get conn, post_tag_path(conn, :edit, post_tag)
    assert html_response(conn, 200) =~ "Edit post tag"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post_tag = Repo.insert! %PostTag{}
    conn = put conn, post_tag_path(conn, :update, post_tag), post_tag: @valid_attrs
    assert redirected_to(conn) == post_tag_path(conn, :show, post_tag)
    assert Repo.get_by(PostTag, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_tag = Repo.insert! %PostTag{}
    conn = put conn, post_tag_path(conn, :update, post_tag), post_tag: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post tag"
  end

  test "deletes chosen resource", %{conn: conn} do
    post_tag = Repo.insert! %PostTag{}
    conn = delete conn, post_tag_path(conn, :delete, post_tag)
    assert redirected_to(conn) == post_tag_path(conn, :index)
    refute Repo.get(PostTag, post_tag.id)
  end
end
