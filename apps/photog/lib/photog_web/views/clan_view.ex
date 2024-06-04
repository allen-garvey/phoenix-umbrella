defmodule PhotogWeb.ClanView do
  use PhotogWeb, :view
  alias PhotogWeb.ClanView

  def render("index.json", %{clans: clans}) do
    %{data: render_many(clans, ClanView, "clan.json")}
  end

  def render("show.json", %{clan: clan}) do
    %{data: render_one(clan, ClanView, "clan.json")}
  end

  def render("clan.json", %{clan: clan}) do
    person_ids = Common.ViewHelpers.Resource.get_maybe_loaded_or_default(clan.clan_persons, [])
    |> Enum.map(fn clan_person -> clan_person.person_id end)

    %{
      id: clan.id,
      name: clan.name,
      person_ids: person_ids,
    }
  end
end
