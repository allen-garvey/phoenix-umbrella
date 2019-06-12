defmodule SerenWeb.FileTypeControllerTest do
  use SerenWeb.ConnCase

  alias Seren.Player
  alias Seren.Player.FileType

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:file_type) do
    {:ok, file_type} = Player.create_file_type(@create_attrs)
    file_type
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all file_types", %{conn: conn} do
      conn = get conn, file_type_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create file_type" do
    test "renders file_type when data is valid", %{conn: conn} do
      conn = post conn, file_type_path(conn, :create), file_type: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, file_type_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, file_type_path(conn, :create), file_type: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update file_type" do
    setup [:create_file_type]

    test "renders file_type when data is valid", %{conn: conn, file_type: %FileType{id: id} = file_type} do
      conn = put conn, file_type_path(conn, :update, file_type), file_type: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, file_type_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, file_type: file_type} do
      conn = put conn, file_type_path(conn, :update, file_type), file_type: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete file_type" do
    setup [:create_file_type]

    test "deletes chosen file_type", %{conn: conn, file_type: file_type} do
      conn = delete conn, file_type_path(conn, :delete, file_type)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, file_type_path(conn, :show, file_type)
      end
    end
  end

  defp create_file_type(_) do
    file_type = fixture(:file_type)
    {:ok, file_type: file_type}
  end
end
