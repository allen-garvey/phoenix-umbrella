defmodule PhotogWeb.ImageControllerTest do
  use PhotogWeb.ConnCase

  alias Photog.Api
  alias Photog.Api.Image

  @create_attrs %{apple_photos_id: 42, creation_time: "2010-04-17 14:00:00.000000Z", is_favorite: true, master_path: "some master_path", mini_thumbnail_path: "some mini_thumbnail_path", thumbnail_path: "some thumbnail_path"}
  @update_attrs %{apple_photos_id: 43, creation_time: "2011-05-18 15:01:01.000000Z", is_favorite: false, master_path: "some updated master_path", mini_thumbnail_path: "some updated mini_thumbnail_path", thumbnail_path: "some updated thumbnail_path"}
  @invalid_attrs %{apple_photos_id: nil, creation_time: nil, is_favorite: nil, master_path: nil, mini_thumbnail_path: nil, thumbnail_path: nil}

  def fixture(:image) do
    {:ok, image} = Api.create_image(@create_attrs)
    image
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all images", %{conn: conn} do
      conn = get conn, image_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create image" do
    test "renders image when data is valid", %{conn: conn} do
      conn = post conn, image_path(conn, :create), image: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "apple_photos_id" => 42,
        "creation_time" => "2010-04-17 14:00:00.000000Z",
        "is_favorite" => true,
        "master_path" => "some master_path",
        "mini_thumbnail_path" => "some mini_thumbnail_path",
        "thumbnail_path" => "some thumbnail_path"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, image_path(conn, :create), image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update image" do
    setup [:create_image]

    test "renders image when data is valid", %{conn: conn, image: %Image{id: id} = image} do
      conn = put conn, image_path(conn, :update, image), image: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "apple_photos_id" => 43,
        "creation_time" => "2011-05-18 15:01:01.000000Z",
        "is_favorite" => false,
        "master_path" => "some updated master_path",
        "mini_thumbnail_path" => "some updated mini_thumbnail_path",
        "thumbnail_path" => "some updated thumbnail_path"}
    end

    test "renders errors when data is invalid", %{conn: conn, image: image} do
      conn = put conn, image_path(conn, :update, image), image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete image" do
    setup [:create_image]

    test "deletes chosen image", %{conn: conn, image: image} do
      conn = delete conn, image_path(conn, :delete, image)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, image_path(conn, :show, image)
      end
    end
  end

  defp create_image(_) do
    image = fixture(:image)
    {:ok, image: image}
  end
end
