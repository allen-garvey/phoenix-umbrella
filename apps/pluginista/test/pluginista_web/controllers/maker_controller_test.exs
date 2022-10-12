defmodule PluginistaWeb.MakerControllerTest do
  use PluginistaWeb.ConnCase

  import Pluginista.AdminFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all makers", %{conn: conn} do
      conn = get(conn, Routes.maker_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Makers"
    end
  end

  describe "new maker" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.maker_path(conn, :new))
      assert html_response(conn, 200) =~ "New Maker"
    end
  end

  describe "create maker" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.maker_path(conn, :create), maker: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.maker_path(conn, :show, id)

      conn = get(conn, Routes.maker_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Maker"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.maker_path(conn, :create), maker: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Maker"
    end
  end

  describe "edit maker" do
    setup [:create_maker]

    test "renders form for editing chosen maker", %{conn: conn, maker: maker} do
      conn = get(conn, Routes.maker_path(conn, :edit, maker))
      assert html_response(conn, 200) =~ "Edit Maker"
    end
  end

  describe "update maker" do
    setup [:create_maker]

    test "redirects when data is valid", %{conn: conn, maker: maker} do
      conn = put(conn, Routes.maker_path(conn, :update, maker), maker: @update_attrs)
      assert redirected_to(conn) == Routes.maker_path(conn, :show, maker)

      conn = get(conn, Routes.maker_path(conn, :show, maker))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, maker: maker} do
      conn = put(conn, Routes.maker_path(conn, :update, maker), maker: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Maker"
    end
  end

  describe "delete maker" do
    setup [:create_maker]

    test "deletes chosen maker", %{conn: conn, maker: maker} do
      conn = delete(conn, Routes.maker_path(conn, :delete, maker))
      assert redirected_to(conn) == Routes.maker_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.maker_path(conn, :show, maker))
      end
    end
  end

  defp create_maker(_) do
    maker = maker_fixture()
    %{maker: maker}
  end
end
