defmodule SerenWeb.ComposerControllerTest do
  use SerenWeb.ConnCase

  alias Seren.Player
  alias Seren.Player.Composer

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:composer) do
    {:ok, composer} = Player.create_composer(@create_attrs)
    composer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all composers", %{conn: conn} do
      conn = get conn, composer_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create composer" do
    test "renders composer when data is valid", %{conn: conn} do
      conn = post conn, composer_path(conn, :create), composer: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, composer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, composer_path(conn, :create), composer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update composer" do
    setup [:create_composer]

    test "renders composer when data is valid", %{conn: conn, composer: %Composer{id: id} = composer} do
      conn = put conn, composer_path(conn, :update, composer), composer: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, composer_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, composer: composer} do
      conn = put conn, composer_path(conn, :update, composer), composer: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete composer" do
    setup [:create_composer]

    test "deletes chosen composer", %{conn: conn, composer: composer} do
      conn = delete conn, composer_path(conn, :delete, composer)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, composer_path(conn, :show, composer)
      end
    end
  end

  defp create_composer(_) do
    composer = fixture(:composer)
    {:ok, composer: composer}
  end
end
