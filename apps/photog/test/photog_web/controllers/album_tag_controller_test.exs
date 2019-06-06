defmodule PhotogWeb.AlbumTagControllerTest do
  use PhotogWeb.ConnCase

  alias Photog.Api
  alias Photog.Api.AlbumTag

  @create_attrs %{
    album_order: 42
  }
  @update_attrs %{
    album_order: 43
  }
  @invalid_attrs %{album_order: nil}

  def fixture(:album_tag) do
    {:ok, album_tag} = Api.create_album_tag(@create_attrs)
    album_tag
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all album_tags", %{conn: conn} do
      conn = get(conn, Routes.album_tag_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create album_tag" do
    test "renders album_tag when data is valid", %{conn: conn} do
      conn = post(conn, Routes.album_tag_path(conn, :create), album_tag: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.album_tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "album_order" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.album_tag_path(conn, :create), album_tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update album_tag" do
    setup [:create_album_tag]

    test "renders album_tag when data is valid", %{conn: conn, album_tag: %AlbumTag{id: id} = album_tag} do
      conn = put(conn, Routes.album_tag_path(conn, :update, album_tag), album_tag: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.album_tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "album_order" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, album_tag: album_tag} do
      conn = put(conn, Routes.album_tag_path(conn, :update, album_tag), album_tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete album_tag" do
    setup [:create_album_tag]

    test "deletes chosen album_tag", %{conn: conn, album_tag: album_tag} do
      conn = delete(conn, Routes.album_tag_path(conn, :delete, album_tag))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.album_tag_path(conn, :show, album_tag))
      end
    end
  end

  defp create_album_tag(_) do
    album_tag = fixture(:album_tag)
    {:ok, album_tag: album_tag}
  end
end
