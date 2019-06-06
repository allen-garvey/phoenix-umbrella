defmodule PhotogWeb.AlbumImageControllerTest do
  use PhotogWeb.ConnCase

  alias Photog.Api
  alias Photog.Api.AlbumImage

  @create_attrs %{order: 42}
  @update_attrs %{order: 43}
  @invalid_attrs %{order: nil}

  def fixture(:album_image) do
    {:ok, album_image} = Api.create_album_image(@create_attrs)
    album_image
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all album_images", %{conn: conn} do
      conn = get conn, album_image_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create album_image" do
    test "renders album_image when data is valid", %{conn: conn} do
      conn = post conn, album_image_path(conn, :create), album_image: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, album_image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "order" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, album_image_path(conn, :create), album_image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update album_image" do
    setup [:create_album_image]

    test "renders album_image when data is valid", %{conn: conn, album_image: %AlbumImage{id: id} = album_image} do
      conn = put conn, album_image_path(conn, :update, album_image), album_image: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, album_image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "order" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, album_image: album_image} do
      conn = put conn, album_image_path(conn, :update, album_image), album_image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete album_image" do
    setup [:create_album_image]

    test "deletes chosen album_image", %{conn: conn, album_image: album_image} do
      conn = delete conn, album_image_path(conn, :delete, album_image)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, album_image_path(conn, :show, album_image)
      end
    end
  end

  defp create_album_image(_) do
    album_image = fixture(:album_image)
    {:ok, album_image: album_image}
  end
end
