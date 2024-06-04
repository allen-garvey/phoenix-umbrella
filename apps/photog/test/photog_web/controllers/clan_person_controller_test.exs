defmodule PhotogWeb.ClanPersonControllerTest do
  use PhotogWeb.ConnCase

  import Photog.ApiFixtures

  alias Photog.Api.ClanPerson

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clan_persons", %{conn: conn} do
      conn = get(conn, Routes.clan_person_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clan_person" do
    test "renders clan_person when data is valid", %{conn: conn} do
      conn = post(conn, Routes.clan_person_path(conn, :create), clan_person: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.clan_person_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.clan_person_path(conn, :create), clan_person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clan_person" do
    setup [:create_clan_person]

    test "renders clan_person when data is valid", %{conn: conn, clan_person: %ClanPerson{id: id} = clan_person} do
      conn = put(conn, Routes.clan_person_path(conn, :update, clan_person), clan_person: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.clan_person_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, clan_person: clan_person} do
      conn = put(conn, Routes.clan_person_path(conn, :update, clan_person), clan_person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clan_person" do
    setup [:create_clan_person]

    test "deletes chosen clan_person", %{conn: conn, clan_person: clan_person} do
      conn = delete(conn, Routes.clan_person_path(conn, :delete, clan_person))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.clan_person_path(conn, :show, clan_person))
      end
    end
  end

  defp create_clan_person(_) do
    clan_person = clan_person_fixture()
    %{clan_person: clan_person}
  end
end
