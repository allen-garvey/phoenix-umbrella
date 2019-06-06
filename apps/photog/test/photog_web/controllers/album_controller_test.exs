defmodule PhotogWeb.AlbumControllerTest do
  use PhotogWeb.ConnCase

  alias Photog.Api
  alias Photog.Api.Album

  @create_attrs %{apple_photos_id: 42, folder_order: 42, name: "some name"}
  @update_attrs %{apple_photos_id: 43, folder_order: 43, name: "some updated name"}
  @invalid_attrs %{apple_photos_id: nil, folder_order: nil, name: nil}

  def fixture(:album) do
    {:ok, album} = Api.create_album(@create_attrs)
    album
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all albums", %{conn: conn} do
      conn = get conn, album_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create album" do
    test "renders album when data is valid", %{conn: conn} do
      conn = post conn, album_path(conn, :create), album: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, album_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "apple_photos_id" => 42,
        "folder_order" => 42,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, album_path(conn, :create), album: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update album" do
    setup [:create_album]

    test "renders album when data is valid", %{conn: conn, album: %Album{id: id} = album} do
      conn = put conn, album_path(conn, :update, album), album: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, album_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "apple_photos_id" => 43,
        "folder_order" => 43,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, album: album} do
      conn = put conn, album_path(conn, :update, album), album: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete album" do
    setup [:create_album]

    test "deletes chosen album", %{conn: conn, album: album} do
      conn = delete conn, album_path(conn, :delete, album)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, album_path(conn, :show, album)
      end
    end
  end

  defp create_album(_) do
    album = fixture(:album)
    {:ok, album: album}
  end
end
