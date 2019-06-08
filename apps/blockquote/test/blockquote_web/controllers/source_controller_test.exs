defmodule BlockquoteWeb.SourceControllerTest do
  use BlockquoteWeb.ConnCase

  alias Blockquote.Admin

  @create_attrs %{subtitle: "some subtitle", title: "some title", url: "some url"}
  @update_attrs %{subtitle: "some updated subtitle", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{subtitle: nil, title: nil, url: nil}

  def fixture(:source) do
    {:ok, source} = Admin.create_source(@create_attrs)
    source
  end

  describe "index" do
    test "lists all sources", %{conn: conn} do
      conn = get conn, source_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Sources"
    end
  end

  describe "new source" do
    test "renders form", %{conn: conn} do
      conn = get conn, source_path(conn, :new)
      assert html_response(conn, 200) =~ "New Source"
    end
  end

  describe "create source" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, source_path(conn, :create), source: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == source_path(conn, :show, id)

      conn = get conn, source_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Source"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, source_path(conn, :create), source: @invalid_attrs
      assert html_response(conn, 200) =~ "New Source"
    end
  end

  describe "edit source" do
    setup [:create_source]

    test "renders form for editing chosen source", %{conn: conn, source: source} do
      conn = get conn, source_path(conn, :edit, source)
      assert html_response(conn, 200) =~ "Edit Source"
    end
  end

  describe "update source" do
    setup [:create_source]

    test "redirects when data is valid", %{conn: conn, source: source} do
      conn = put conn, source_path(conn, :update, source), source: @update_attrs
      assert redirected_to(conn) == source_path(conn, :show, source)

      conn = get conn, source_path(conn, :show, source)
      assert html_response(conn, 200) =~ "some updated subtitle"
    end

    test "renders errors when data is invalid", %{conn: conn, source: source} do
      conn = put conn, source_path(conn, :update, source), source: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Source"
    end
  end

  describe "delete source" do
    setup [:create_source]

    test "deletes chosen source", %{conn: conn, source: source} do
      conn = delete conn, source_path(conn, :delete, source)
      assert redirected_to(conn) == source_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, source_path(conn, :show, source)
      end
    end
  end

  defp create_source(_) do
    source = fixture(:source)
    {:ok, source: source}
  end
end
