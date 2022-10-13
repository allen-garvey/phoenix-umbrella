defmodule PluginistaWeb.PluginCategoryControllerTest do
  use PluginistaWeb.ConnCase

  import Pluginista.AdminFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all plugin_categories", %{conn: conn} do
      conn = get(conn, Routes.plugin_category_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Plugin categories"
    end
  end

  describe "new plugin_category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.plugin_category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Plugin category"
    end
  end

  describe "create plugin_category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.plugin_category_path(conn, :create), plugin_category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.plugin_category_path(conn, :show, id)

      conn = get(conn, Routes.plugin_category_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Plugin category"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.plugin_category_path(conn, :create), plugin_category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Plugin category"
    end
  end

  describe "edit plugin_category" do
    setup [:create_plugin_category]

    test "renders form for editing chosen plugin_category", %{conn: conn, plugin_category: plugin_category} do
      conn = get(conn, Routes.plugin_category_path(conn, :edit, plugin_category))
      assert html_response(conn, 200) =~ "Edit Plugin category"
    end
  end

  describe "update plugin_category" do
    setup [:create_plugin_category]

    test "redirects when data is valid", %{conn: conn, plugin_category: plugin_category} do
      conn = put(conn, Routes.plugin_category_path(conn, :update, plugin_category), plugin_category: @update_attrs)
      assert redirected_to(conn) == Routes.plugin_category_path(conn, :show, plugin_category)

      conn = get(conn, Routes.plugin_category_path(conn, :show, plugin_category))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, plugin_category: plugin_category} do
      conn = put(conn, Routes.plugin_category_path(conn, :update, plugin_category), plugin_category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Plugin category"
    end
  end

  describe "delete plugin_category" do
    setup [:create_plugin_category]

    test "deletes chosen plugin_category", %{conn: conn, plugin_category: plugin_category} do
      conn = delete(conn, Routes.plugin_category_path(conn, :delete, plugin_category))
      assert redirected_to(conn) == Routes.plugin_category_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.plugin_category_path(conn, :show, plugin_category))
      end
    end
  end

  defp create_plugin_category(_) do
    plugin_category = plugin_category_fixture()
    %{plugin_category: plugin_category}
  end
end
