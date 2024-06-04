defmodule PhotogWeb.ClanControllerTest do
  use PhotogWeb.ConnCase

  import Photog.ApiFixtures

  alias Photog.Api.Clan

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clans", %{conn: conn} do
      conn = get(conn, Routes.clan_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clan" do
    test "renders clan when data is valid", %{conn: conn} do
      conn = post(conn, Routes.clan_path(conn, :create), clan: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.clan_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.clan_path(conn, :create), clan: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clan" do
    setup [:create_clan]

    test "renders clan when data is valid", %{conn: conn, clan: %Clan{id: id} = clan} do
      conn = put(conn, Routes.clan_path(conn, :update, clan), clan: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.clan_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, clan: clan} do
      conn = put(conn, Routes.clan_path(conn, :update, clan), clan: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clan" do
    setup [:create_clan]

    test "deletes chosen clan", %{conn: conn, clan: clan} do
      conn = delete(conn, Routes.clan_path(conn, :delete, clan))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.clan_path(conn, :show, clan))
      end
    end
  end

  defp create_clan(_) do
    clan = clan_fixture()
    %{clan: clan}
  end
end
