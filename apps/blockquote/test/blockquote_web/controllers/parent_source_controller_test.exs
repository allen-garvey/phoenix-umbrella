defmodule BlockquoteWeb.ParentSourceControllerTest do
  use BlockquoteWeb.ConnCase

  alias Blockquote.Admin

  @create_attrs %{subtitle: "some subtitle", title: "some title", url: "some url"}
  @update_attrs %{subtitle: "some updated subtitle", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{subtitle: nil, title: nil, url: nil}

  def fixture(:parent_source) do
    {:ok, parent_source} = Admin.create_parent_source(@create_attrs)
    parent_source
  end

  describe "index" do
    test "lists all parent_sources", %{conn: conn} do
      conn = get conn, parent_source_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Parent sources"
    end
  end

  describe "new parent_source" do
    test "renders form", %{conn: conn} do
      conn = get conn, parent_source_path(conn, :new)
      assert html_response(conn, 200) =~ "New Parent source"
    end
  end

  describe "create parent_source" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, parent_source_path(conn, :create), parent_source: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == parent_source_path(conn, :show, id)

      conn = get conn, parent_source_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Parent source"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, parent_source_path(conn, :create), parent_source: @invalid_attrs
      assert html_response(conn, 200) =~ "New Parent source"
    end
  end

  describe "edit parent_source" do
    setup [:create_parent_source]

    test "renders form for editing chosen parent_source", %{conn: conn, parent_source: parent_source} do
      conn = get conn, parent_source_path(conn, :edit, parent_source)
      assert html_response(conn, 200) =~ "Edit Parent source"
    end
  end

  describe "update parent_source" do
    setup [:create_parent_source]

    test "redirects when data is valid", %{conn: conn, parent_source: parent_source} do
      conn = put conn, parent_source_path(conn, :update, parent_source), parent_source: @update_attrs
      assert redirected_to(conn) == parent_source_path(conn, :show, parent_source)

      conn = get conn, parent_source_path(conn, :show, parent_source)
      assert html_response(conn, 200) =~ "some updated subtitle"
    end

    test "renders errors when data is invalid", %{conn: conn, parent_source: parent_source} do
      conn = put conn, parent_source_path(conn, :update, parent_source), parent_source: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Parent source"
    end
  end

  describe "delete parent_source" do
    setup [:create_parent_source]

    test "deletes chosen parent_source", %{conn: conn, parent_source: parent_source} do
      conn = delete conn, parent_source_path(conn, :delete, parent_source)
      assert redirected_to(conn) == parent_source_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, parent_source_path(conn, :show, parent_source)
      end
    end
  end

  defp create_parent_source(_) do
    parent_source = fixture(:parent_source)
    {:ok, parent_source: parent_source}
  end
end
