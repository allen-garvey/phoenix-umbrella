defmodule PhotogWeb.ClanPersonController do
  use PhotogWeb, :controller

  alias Photog.Api
  alias Photog.Api.ClanPerson

  action_fallback PhotogWeb.FallbackController

  def index(conn, _params) do
    clan_persons = Api.list_clan_persons()
    render(conn, "index.json", clan_persons: clan_persons)
  end

  def create(conn, %{"clan_person" => clan_person_params}) do
    with {:ok, %ClanPerson{} = clan_person} <- Api.create_clan_person(clan_person_params) do
      conn
      |> put_status(:created)
      |> render("show.json", clan_person: clan_person)
    end
  end

  def show(conn, %{"id" => id}) do
    clan_person = Api.get_clan_person!(id)
    render(conn, "show.json", clan_person: clan_person)
  end

  def update(conn, %{"id" => id, "clan_person" => clan_person_params}) do
    clan_person = Api.get_clan_person!(id)

    with {:ok, %ClanPerson{} = clan_person} <- Api.update_clan_person(clan_person, clan_person_params) do
      render(conn, "show.json", clan_person: clan_person)
    end
  end

  def delete(conn, %{"id" => id}) do
    clan_person = Api.get_clan_person!(id)

    with {:ok, %ClanPerson{}} <- Api.delete_clan_person(clan_person) do
      send_resp(conn, :no_content, "")
    end
  end
end
