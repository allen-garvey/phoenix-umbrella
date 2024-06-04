defmodule PhotogWeb.ClanController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.Clan

  action_fallback PhotogWeb.FallbackController

  def index(conn, _params) do
    clans = Api.list_clans()
    render(conn, "index.json", clans: clans)
  end

  def create(conn, %{"clan" => clan_params}) do
    with {:ok, %Clan{} = clan} <- Api.create_clan(clan_params) do
      conn
      |> put_status(:created)
      |> render("show.json", clan: clan)
    end
  end

  def show(conn, %{"id" => id}) do
    clan = Api.get_clan!(id)
    render(conn, "show.json", clan: clan)
  end

  def update(conn, %{"id" => id, "clan" => clan_params}) do
    clan = Api.get_clan!(id)

    with {:ok, %Clan{} = clan} <- Api.update_clan(clan, clan_params) do
      render(conn, "show.json", clan: clan)
    end
  end

  def delete(conn, %{"id" => id}) do
    clan = Api.get_clan!(id)

    with {:ok, %Clan{}} <- Api.delete_clan(clan) do
      send_resp(conn, :no_content, "")
    end
  end
end
