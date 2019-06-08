defmodule BlockquoteWeb.SourceTypeControllerTest do
  use BlockquoteWeb.ConnCase

  alias Blockquote.Admin

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:source_type) do
    {:ok, source_type} = Admin.create_source_type(@create_attrs)
    source_type
  end

  describe "index" do
    test "lists all source_types", %{conn: conn} do
      conn = get conn, source_type_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Source types"
    end
  end

  describe "new source_type" do
    test "renders form", %{conn: conn} do
      conn = get conn, source_type_path(conn, :new)
      assert html_response(conn, 200) =~ "New Source type"
    end
  end

  describe "create source_type" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, source_type_path(conn, :create), source_type: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == source_type_path(conn, :show, id)

      conn = get conn, source_type_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Source type"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, source_type_path(conn, :create), source_type: @invalid_attrs
      assert html_response(conn, 200) =~ "New Source type"
    end
  end

  describe "edit source_type" do
    setup [:create_source_type]

    test "renders form for editing chosen source_type", %{conn: conn, source_type: source_type} do
      conn = get conn, source_type_path(conn, :edit, source_type)
      assert html_response(conn, 200) =~ "Edit Source type"
    end
  end

  describe "update source_type" do
    setup [:create_source_type]

    test "redirects when data is valid", %{conn: conn, source_type: source_type} do
      conn = put conn, source_type_path(conn, :update, source_type), source_type: @update_attrs
      assert redirected_to(conn) == source_type_path(conn, :show, source_type)

      conn = get conn, source_type_path(conn, :show, source_type)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, source_type: source_type} do
      conn = put conn, source_type_path(conn, :update, source_type), source_type: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Source type"
    end
  end

  describe "delete source_type" do
    setup [:create_source_type]

    test "deletes chosen source_type", %{conn: conn, source_type: source_type} do
      conn = delete conn, source_type_path(conn, :delete, source_type)
      assert redirected_to(conn) == source_type_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, source_type_path(conn, :show, source_type)
      end
    end
  end

  defp create_source_type(_) do
    source_type = fixture(:source_type)
    {:ok, source_type: source_type}
  end
end
