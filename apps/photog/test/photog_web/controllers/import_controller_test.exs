defmodule PhotogWeb.ImportControllerTest do
  use PhotogWeb.ConnCase

  alias Photog.Api
  alias Photog.Api.Import

  @create_attrs %{
    import_time: ~N[2010-04-17 14:00:00]
  }
  @update_attrs %{
    import_time: ~N[2011-05-18 15:01:01]
  }
  @invalid_attrs %{import_time: nil}

  def fixture(:import) do
    {:ok, import} = Api.create_import(@create_attrs)
    import
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all imports", %{conn: conn} do
      conn = get(conn, Routes.import_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create import" do
    test "renders import when data is valid", %{conn: conn} do
      conn = post(conn, Routes.import_path(conn, :create), import: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.import_path(conn, :show, id))

      assert %{
               "id" => id,
               "import_time" => "2010-04-17T14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.import_path(conn, :create), import: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update import" do
    setup [:create_import]

    test "renders import when data is valid", %{conn: conn, import: %Import{id: id} = import} do
      conn = put(conn, Routes.import_path(conn, :update, import), import: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.import_path(conn, :show, id))

      assert %{
               "id" => id,
               "import_time" => "2011-05-18T15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, import: import} do
      conn = put(conn, Routes.import_path(conn, :update, import), import: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete import" do
    setup [:create_import]

    test "deletes chosen import", %{conn: conn, import: import} do
      conn = delete(conn, Routes.import_path(conn, :delete, import))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.import_path(conn, :show, import))
      end
    end
  end

  defp create_import(_) do
    import = fixture(:import)
    {:ok, import: import}
  end
end
