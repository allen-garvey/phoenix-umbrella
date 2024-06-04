defmodule PhotogWeb.ClanPersonView do
  use PhotogWeb, :view
  alias PhotogWeb.ClanPersonView

  def render("index.json", %{clan_persons: clan_persons}) do
    %{data: render_many(clan_persons, ClanPersonView, "clan_person.json")}
  end

  def render("show.json", %{clan_person: clan_person}) do
    %{data: render_one(clan_person, ClanPersonView, "clan_person.json")}
  end

  def render("clan_person.json", %{clan_person: clan_person}) do
    %{
      clan_id: clan_person.clan_id,
      person_id: clan_person.person_id,
    }
  end
end
