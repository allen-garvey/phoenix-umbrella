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
    %{
      id: clan.id,
      name: clan.name
    }
  end
end
