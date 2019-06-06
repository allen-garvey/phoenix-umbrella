defmodule PhotogWeb.PersonImageControllerTest do
  use PhotogWeb.ConnCase

  alias Photog.Api
  alias Photog.Api.PersonImage

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:person_image) do
    {:ok, person_image} = Api.create_person_image(@create_attrs)
    person_image
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all person_images", %{conn: conn} do
      conn = get conn, person_image_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create person_image" do
    test "renders person_image when data is valid", %{conn: conn} do
      conn = post conn, person_image_path(conn, :create), person_image: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, person_image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, person_image_path(conn, :create), person_image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update person_image" do
    setup [:create_person_image]

    test "renders person_image when data is valid", %{conn: conn, person_image: %PersonImage{id: id} = person_image} do
      conn = put conn, person_image_path(conn, :update, person_image), person_image: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, person_image_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, person_image: person_image} do
      conn = put conn, person_image_path(conn, :update, person_image), person_image: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete person_image" do
    setup [:create_person_image]

    test "deletes chosen person_image", %{conn: conn, person_image: person_image} do
      conn = delete conn, person_image_path(conn, :delete, person_image)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, person_image_path(conn, :show, person_image)
      end
    end
  end

  defp create_person_image(_) do
    person_image = fixture(:person_image)
    {:ok, person_image: person_image}
  end
end
