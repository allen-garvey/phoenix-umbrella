defmodule PhotogWeb.YearImageControllerTest do
  use PhotogWeb.ConnCase

  import Photog.ApiFixtures

  alias Photog.Api.YearImage

  @create_attrs %{
    year: 42
  }
  @update_attrs %{
    year: 43
  }
  @invalid_attrs %{year: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all year_images", %{conn: conn} do
      conn = get(conn, Routes.year_image_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create year_image" do
    test "renders year_image when data is valid", %{conn: conn} do
      conn = post(conn, Routes.year_image_path(conn, :create), year_image: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.year_image_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "year" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.year_image_path(conn, :create), year_image: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update year_image" do
    setup [:create_year_image]

    test "renders year_image when data is valid", %{conn: conn, year_image: %YearImage{id: id} = year_image} do
      conn = put(conn, Routes.year_image_path(conn, :update, year_image), year_image: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.year_image_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "year" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, year_image: year_image} do
      conn = put(conn, Routes.year_image_path(conn, :update, year_image), year_image: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete year_image" do
    setup [:create_year_image]

    test "deletes chosen year_image", %{conn: conn, year_image: year_image} do
      conn = delete(conn, Routes.year_image_path(conn, :delete, year_image))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.year_image_path(conn, :show, year_image))
      end
    end
  end

  defp create_year_image(_) do
    year_image = year_image_fixture()
    %{year_image: year_image}
  end
end
