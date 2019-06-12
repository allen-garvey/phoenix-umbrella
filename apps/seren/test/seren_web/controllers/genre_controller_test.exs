defmodule SerenWeb.GenreControllerTest do
  use SerenWeb.ConnCase

  alias Seren.Player
  alias Seren.Player.Genre

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:genre) do
    {:ok, genre} = Player.create_genre(@create_attrs)
    genre
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all genres", %{conn: conn} do
      conn = get conn, genre_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create genre" do
    test "renders genre when data is valid", %{conn: conn} do
      conn = post conn, genre_path(conn, :create), genre: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, genre_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, genre_path(conn, :create), genre: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update genre" do
    setup [:create_genre]

    test "renders genre when data is valid", %{conn: conn, genre: %Genre{id: id} = genre} do
      conn = put conn, genre_path(conn, :update, genre), genre: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, genre_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, genre: genre} do
      conn = put conn, genre_path(conn, :update, genre), genre: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete genre" do
    setup [:create_genre]

    test "deletes chosen genre", %{conn: conn, genre: genre} do
      conn = delete conn, genre_path(conn, :delete, genre)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, genre_path(conn, :show, genre)
      end
    end
  end

  defp create_genre(_) do
    genre = fixture(:genre)
    {:ok, genre: genre}
  end
end
