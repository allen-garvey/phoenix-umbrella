defmodule Artour.PostImageControllerTest do
  use Artour.ConnCase

  alias Artour.PostImage
  @valid_attrs %{caption: "some content", order: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_image_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing post images"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_image_path(conn, :new)
    assert html_response(conn, 200) =~ "New post image"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_image_path(conn, :create), post_image: @valid_attrs
    assert redirected_to(conn) == post_image_path(conn, :index)
    assert Repo.get_by(PostImage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_image_path(conn, :create), post_image: @invalid_attrs
    assert html_response(conn, 200) =~ "New post image"
  end

  test "shows chosen resource", %{conn: conn} do
    post_image = Repo.insert! %PostImage{}
    conn = get conn, post_image_path(conn, :show, post_image)
    assert html_response(conn, 200) =~ "Show post image"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_image_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post_image = Repo.insert! %PostImage{}
    conn = get conn, post_image_path(conn, :edit, post_image)
    assert html_response(conn, 200) =~ "Edit post image"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post_image = Repo.insert! %PostImage{}
    conn = put conn, post_image_path(conn, :update, post_image), post_image: @valid_attrs
    assert redirected_to(conn) == post_image_path(conn, :show, post_image)
    assert Repo.get_by(PostImage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_image = Repo.insert! %PostImage{}
    conn = put conn, post_image_path(conn, :update, post_image), post_image: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post image"
  end

  test "deletes chosen resource", %{conn: conn} do
    post_image = Repo.insert! %PostImage{}
    conn = delete conn, post_image_path(conn, :delete, post_image)
    assert redirected_to(conn) == post_image_path(conn, :index)
    refute Repo.get(PostImage, post_image.id)
  end
end
