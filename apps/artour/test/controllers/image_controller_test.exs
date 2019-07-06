defmodule Artour.ImageControllerTest do
  use Artour.ConnCase

  alias Artour.Image
  @valid_attrs %{completion_date: %{day: 17, month: 4, year: 2010}, description: "some content", filename_large: "some content", filename_medium: "some content", filename_small: "some content", filename_thumbnail: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, image_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing images"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, image_path(conn, :new)
    assert html_response(conn, 200) =~ "New image"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, image_path(conn, :create), image: @valid_attrs
    assert redirected_to(conn) == image_path(conn, :index)
    assert Repo.get_by(Image, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, image_path(conn, :create), image: @invalid_attrs
    assert html_response(conn, 200) =~ "New image"
  end

  test "shows chosen resource", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = get conn, image_path(conn, :show, image)
    assert html_response(conn, 200) =~ "Show image"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, image_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = get conn, image_path(conn, :edit, image)
    assert html_response(conn, 200) =~ "Edit image"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = put conn, image_path(conn, :update, image), image: @valid_attrs
    assert redirected_to(conn) == image_path(conn, :show, image)
    assert Repo.get_by(Image, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = put conn, image_path(conn, :update, image), image: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit image"
  end

  test "deletes chosen resource", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = delete conn, image_path(conn, :delete, image)
    assert redirected_to(conn) == image_path(conn, :index)
    refute Repo.get(Image, image.id)
  end
end
