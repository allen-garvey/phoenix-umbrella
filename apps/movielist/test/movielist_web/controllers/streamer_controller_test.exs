defmodule MovielistWeb.StreamerControllerTest do
  use MovielistWeb.ConnCase

  alias Movielist.Admin

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:streamer) do
    {:ok, streamer} = Admin.create_streamer(@create_attrs)
    streamer
  end

  describe "index" do
    test "lists all streamers", %{conn: conn} do
      conn = get(conn, Routes.streamer_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Streamers"
    end
  end

  describe "new streamer" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.streamer_path(conn, :new))
      assert html_response(conn, 200) =~ "New Streamer"
    end
  end

  describe "create streamer" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.streamer_path(conn, :create), streamer: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.streamer_path(conn, :show, id)

      conn = get(conn, Routes.streamer_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Streamer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.streamer_path(conn, :create), streamer: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Streamer"
    end
  end

  describe "edit streamer" do
    setup [:create_streamer]

    test "renders form for editing chosen streamer", %{conn: conn, streamer: streamer} do
      conn = get(conn, Routes.streamer_path(conn, :edit, streamer))
      assert html_response(conn, 200) =~ "Edit Streamer"
    end
  end

  describe "update streamer" do
    setup [:create_streamer]

    test "redirects when data is valid", %{conn: conn, streamer: streamer} do
      conn = put(conn, Routes.streamer_path(conn, :update, streamer), streamer: @update_attrs)
      assert redirected_to(conn) == Routes.streamer_path(conn, :show, streamer)

      conn = get(conn, Routes.streamer_path(conn, :show, streamer))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, streamer: streamer} do
      conn = put(conn, Routes.streamer_path(conn, :update, streamer), streamer: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Streamer"
    end
  end

  describe "delete streamer" do
    setup [:create_streamer]

    test "deletes chosen streamer", %{conn: conn, streamer: streamer} do
      conn = delete(conn, Routes.streamer_path(conn, :delete, streamer))
      assert redirected_to(conn) == Routes.streamer_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.streamer_path(conn, :show, streamer))
      end
    end
  end

  defp create_streamer(_) do
    streamer = fixture(:streamer)
    %{streamer: streamer}
  end
end
